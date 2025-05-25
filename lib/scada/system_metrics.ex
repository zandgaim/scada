defmodule Scada.SystemMetrics do
  use GenServer
  require Logger

  alias Scada.DBManager

  @poll_interval :timer.seconds(5)
  @cadvisor_url "http://cadvisor:8080/api/v1.3/docker"

  # Client API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Server callbacks
  @impl true
  def init(:ok) do
    schedule_poll()
    {:ok, %{previous_cpu: %{}}}
  end

  @impl true
  def handle_info(:poll, %{previous_cpu: prev_cpu} = state) do
    case get_metrics_from_cadvisor(prev_cpu) do
      {:ok, metrics_list, new_cpu} ->
        Enum.each(metrics_list, fn metrics ->
          :telemetry.execute([:scada, :system, :resources], metrics, %{})
          DBManager.insert_metrics(metrics)
        end)

        schedule_poll()
        {:noreply, %{previous_cpu: new_cpu}}

      {:error, reason} ->
        Logger.error("Failed to fetch metrics from cAdvisor: #{inspect(reason)}")
        schedule_poll()
        {:noreply, state}
    end
  end

  defp schedule_poll do
    Process.send_after(self(), :poll, @poll_interval)
  end

  defp get_metrics_from_cadvisor(prev_stats) do
    url = String.to_charlist(@cadvisor_url)

    case :httpc.request(:get, {url, []}, [], []) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        containers = Jason.decode!(body)

        {metrics, new_stats} =
          containers
          |> Enum.map(fn {id, container} ->
            build_metrics(id, container, prev_stats[id])
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

  defp build_metrics(container_id, container, prev_stat) do
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
              # Convert delta_total from nanoseconds to seconds and calculate percentage
              delta_total / 1_000_000_000 / elapsed_time * 100.0

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
