defmodule Scada.SystemMetrics do
  use GenServer
  require Logger

  alias Scada.DBManager

  @poll_interval :timer.seconds(5)
  @cadvisor_docker_url "http://cadvisor:8080/api/v1.3/docker"
  @cadvisor_machine_url "http://cadvisor:8080/api/v1.3/machine"

  # Client API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Server callbacks
  @impl true
  def init(:ok) do
    case get_machine_cpu_info() do
      {:ok, num_vm_cores} ->
        schedule_poll()
        {:ok, %{previous_cpu: %{}, num_vm_cores: num_vm_cores}}

      {:error, reason} ->
        Logger.error(
          "Failed to get VM CPU info from cAdvisor: #{inspect(reason)}. Defaulting to 1 core for calculations."
        )

        schedule_poll()
        {:ok, %{previous_cpu: %{}, num_vm_cores: 1}}
    end
  end

  @impl true
  def handle_info(:poll, %{previous_cpu: prev_cpu, num_vm_cores: num_vm_cores} = state) do
    case get_metrics_from_cadvisor(prev_cpu, num_vm_cores) do
      {:ok, metrics_list, new_cpu} ->
        Enum.each(metrics_list, fn metrics ->
          DBManager.insert_metrics(metrics)
        end)

        schedule_poll()
        {:noreply, %{state | previous_cpu: new_cpu}}

      {:error, reason} ->
        Logger.error("Failed to fetch metrics from cAdvisor: #{inspect(reason)}")
        schedule_poll()
        {:noreply, state}
    end
  end

  defp schedule_poll do
    Process.send_after(self(), :poll, @poll_interval)
  end

  defp get_metrics_from_cadvisor(prev_stats, num_vm_cores) do
    url = String.to_charlist(@cadvisor_docker_url)

    case :httpc.request(:get, {url, []}, [], []) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        containers = Jason.decode!(body)

        {metrics, new_stats} =
          containers
          |> Enum.map(fn {id, container} ->
            build_metrics(id, container, prev_stats[id], num_vm_cores)
          end)
          |> Enum.filter(&match?({:ok, _}, &1))
          |> Enum.map_reduce(%{}, fn {:ok, {metrics, stat}}, acc ->
            {metrics, Map.put(acc, stat.container_id, stat)}
          end)

        {:ok, metrics, new_stats}

      error ->
        {:error, error}
    end
  end

  defp get_machine_cpu_info do
    url = String.to_charlist(@cadvisor_machine_url)

    case :httpc.request(:get, {url, []}, [], []) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        case Jason.decode(body) do
          {:ok, machine_info} ->
            num_cores =
              Map.get(machine_info, "num_cpu_threads") || Map.get(machine_info, "num_cores")

            if is_integer(num_cores) and num_cores > 0 do
              {:ok, num_cores}
            else
              {:error, "invalid_cpu_info"}
            end

          {:error, e} ->
            Logger.error("Failed to parse cAdvisor machine info JSON: #{inspect(e)}")
            {:error, :json_parse_error}
        end

      error ->
        Logger.error("Failed to fetch cAdvisor machine info: #{inspect(error)}")
        {:error, error}
    end
  end

  defp build_metrics(container_id, container, prev_stat, num_vm_cores) do
    try do
      aliases = container["aliases"] || []
      name = List.first(aliases) || container["name"] || "unknown"

      stats = List.last(container["stats"])
      cpu = stats["cpu"]
      memory = stats["memory"]
      net = stats["network"]

      total_usage = cpu["usage"]["total"]
      # ISO8601 string, e.g., "2023-10-10T12:00:00Z"
      timestamp = stats["timestamp"]

      cpu_util_percent =
        if prev_stat do
          prev_total = prev_stat.total
          prev_timestamp = prev_stat.timestamp
          delta_total = total_usage - prev_total

          case calculate_elapsed_time(prev_timestamp, timestamp) do
            elapsed_time when elapsed_time > 0 ->
              used_cores = delta_total / 1_000_000_000 / elapsed_time

              if num_vm_cores > 0 do
                used_cores / num_vm_cores * 100.0
              else
                Logger.warning("num_vm_cores is 0, CPU utilization set to 0.0 for #{name}")
                0.0
              end

            _ ->
              0.0
          end
        else
          0.0
        end

      metrics = %{
        container_title: name,
        cpu_utilization_percent: cpu_util_percent,
        memory_usage_mb: to_mb(memory["usage"]),
        memory_working_set_mb: to_mb(memory["working_set"]),
        rx_bytes_mb: to_mb(net["rx_bytes"]),
        tx_bytes_mb: to_mb(net["tx_bytes"])
      }

      new_stat = %{container_id: container_id, total: total_usage, timestamp: timestamp}
      {:ok, {metrics, new_stat}}
    rescue
      e ->
        Logger.warning("Error building metrics for #{container_id}: #{inspect(e)}")
        nil
    end
  end

  defp calculate_elapsed_time(prev_timestamp, curr_timestamp) do
    with {:ok, prev_dt, _} <- DateTime.from_iso8601(prev_timestamp),
         {:ok, curr_dt, _} <- DateTime.from_iso8601(curr_timestamp) do
      # Returns difference in seconds
      DateTime.diff(curr_dt, prev_dt)
    else
      _ -> 0
    end
  end

  defp to_mb(bytes) when is_integer(bytes), do: Float.round(bytes / 1024 / 1024, 2)
  defp to_mb(_), do: 0.0
end
