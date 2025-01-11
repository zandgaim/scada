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
          {"Prędkość wiatru", "Main.WindSpeed", :wind_speed},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", :wind_speed},
          {"Kierunek wiatru", "Main.WindDirection", :wind_direction},
          {"Temperatura", "Main.Temperature", :temperature}
        ]
      },
      %{
        title: "PV",
        status_indicator: "Operational",
        items: [
          {"Napięcie", "Main.Tension", :v},
          {"Moc 1", "Main.Pow1", :kw},
          {"Moc 2", "Main.Pow2", :kw},
          {"Moc 3", "Main.Pow3", :kw}
        ]
      }
    ]
  end

  def get_type(atom) do
    Map.get(@types, atom, "")
  end
end
