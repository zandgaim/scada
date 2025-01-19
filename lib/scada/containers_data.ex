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
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "Li-Ion Battery",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "AGM Battery",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Converter",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Converter 2",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "RG1",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Bus",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Converter 3",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "AC/DC Converter",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "RG2",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Charger",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "Wind Turbine",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "SCAP Battery",
        status_indicator: "Operational",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      }
    ]
  end

  def get_type(atom) do
    Map.get(@types, atom, "")
  end
end
