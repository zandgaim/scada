defmodule Scada.Containers do
  def get_containers do
    [
      %{
        title: "Weather Station",
        status_indicator: %{active: false, label: "Online"},
        items: [
          {"Prędkość wiatru", "0m/s"},
          {"Śr. prędkość wiatru", "0.1m/s"},
          {"Kierunek wiatru", "0°"},
          {"Temperatura", "25.3°C"}
        ]
      },
      %{
        title: "PV",
        status_indicator: %{active: true, label: "Operational"},
        items: [
          {"Napięcie", "760V"},
          {"Moc 1", "8kW"},
          {"Moc 2", "7kW"},
          {"Moc 3", "0kW"}
        ]
      }
    ]
  end
end
