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
    {:ok, %{}}
  end

  @impl true
  def handle_info(:poll, state) do
    case get_metrics_from_cadvisor() do
      {:ok, metrics_list} ->
        Enum.each(metrics_list, fn metrics ->
          :telemetry.execute([:scada, :system, :resources], metrics, %{})
          DBManager.insert_metrics(metrics)
        end)

      {:error, reason} ->
        Logger.error("Failed to fetch metrics from cAdvisor: #{inspect(reason)}")
    end

    schedule_poll()
    {:noreply, state}
  end

  defp schedule_poll do
    Process.send_after(self(), :poll, @poll_interval)
  end

  defp get_metrics_from_cadvisor do
    url = String.to_charlist(@cadvisor_url)

    case :httpc.request(:get, {url, []}, [], []) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        containers = Jason.decode!(body)

        metrics =
          containers
          |> Enum.map(fn {_id, container} -> build_metrics(container) end)
          |> Enum.filter(& &1)

        {:ok, metrics}

      error ->
        {:error, error}
    end
  end

  defp build_metrics(container) do
    try do
      aliases = container["aliases"] || []
      name = List.first(aliases) || container["name"] || "unknown"

      stats = List.last(container["stats"])
      cpu = stats["cpu"]
      memory = stats["memory"]
      net = stats["network"]

      %{
        container_title: name,
        cpu_utilization_percent: calculate_cpu_percent(cpu, container),
        memory_usage_mb: memory["usage"] |> to_mb(),
        memory_working_set_mb: memory["working_set"] |> to_mb(),
        rx_bytes_mb: net["rx_bytes"] |> to_mb(),
        tx_bytes_mb: net["tx_bytes"] |> to_mb()
      }
    rescue
      _ -> nil
    end
  end

  defp calculate_cpu_percent(cpu, container) do
    total_usage = cpu["usage"]["total"]
    system_cpu = cpu["usage"]["system"]
    num_cores = container["spec"]["cpu"]["limit"] || 1

    if system_cpu > 0 do
      total_usage / system_cpu * 100.0 / num_cores
    else
      0.0
    end
  end

  defp to_mb(bytes) when is_integer(bytes), do: Float.round(bytes / 1024 / 1024, 2)
  defp to_mb(_), do: 0.0
end
