defmodule Scada.ContainersData do
  @types %{
    wind_speed: "m/s",
    wind_direction: "°",
    temperature: "°C",
    v: "V",
    kw: "kW"
  }

  def get_containers do
    [
      %{
        title: "Weather Station",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "PV",
        status_indicator: "Operational",
        items: [
          {"Napięcie", "Main.Tension", "V", "N/A"},
          {"Moc 1", "Main.Pow1", "kW", "N/A"},
          {"Moc 2", "Main.Pow2", "kW", "N/A"},
          {"Moc 3", "Main.Pow3", "kW", "N/A"}
        ]
      }
    ]
  end

  def get_type(atom) do
    Map.get(@types, atom, "")
  end
end
