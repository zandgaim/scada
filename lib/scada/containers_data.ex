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
        items: [
          # Read
          {"Temperature", "GVL_Visu.stVisu_MeasWeather_read.Temperature", "°C", "N/A"},
          {"Humanity", "GVL_Visu.stVisu_MeasWeather_read.Humanity", "%RH", "N/A"},
          {"Pressure", "GVL_Visu.stVisu_MeasWeather_read.Pressure", "hPa", "N/A"},
          {"WindSpeed", "GVL_Visu.stVisu_MeasWeather_read.WindSpeed", "m/s", "N/A"},
          {"WindDirect", "GVL_Visu.stVisu_MeasWeather_read.WindDirect", "°", "N/A"},
          {"Radiation", "GVL_Visu.stVisu_MeasWeather_read.Radiation", "W/m2", "N/A"},
          {"Brightness", "GVL_Visu.stVisu_MeasWeather_read.Brightness", "kLux", "N/A"},
          {"Connections", "GVL_Visu.stVisu_MeasWeather_read.Connection", "", "N/A"},

          # Set
          {"Switch meter [true/false]", "GVL_Visu.stVisu_MeasWeather_set.bONOFF", "", ""},
        ]
      },
      %{
        title: "AC Grid",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "PV",
        items: []
      },
      %{
        title: "Li-Ion Battery",
        items: [
          # Read
          {"Actual voltage", "GVL_Visu.stVisu_bmsLIION_read.Ubat", "V", "N/A"},
          {"Actual current", "GVL_Visu.stVisu_bmsLIION_read.Ibat", "A", "N/A"},
          {"Actual power", "GVL_Visu.stVisu_bmsLIION_read.Pbat", "W", "N/A"},
          {"SOC", "GVL_Visu.stVisu_bmsLIION_read.SOC", "%", "N/A"},
          {"SOH", "GVL_Visu.stVisu_bmsLIION_read.SOH", "%", "N/A"},
          {"Delta U cells", "GVL_Visu.stVisu_bmsLIION_read.Udiff", "mV", "N/A"},
          {"Max. Temp. cells", "GVL_Visu.stVisu_bmsLIION_read.Tmax", "%", "N/A"},
          {"Baterry status", "GVL_Visu.stVisu_bmsLIION_read.Status", "", "N/A"},
          {"Baterry alarms", "GVL_Visu.stVisu_bmsLIION_read.Alarms", "", "N/A"},
          {"Baterry on/off [true/false]", "GVL_Visu.stVisu_bmsLIION_read.BatState", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_bmsLIION_read.Connection", "", "N/A"},

          # Set
          {"Switch Baterry on/off [true/false]", "GVL_Visu.stVisu_bmsLIION_set.bONOFF", "bool", "N/A"},
          {"Reset Baterry [Rising/Falling edge]", "GVL_Visu.stVisu_bmsLIION_set.bReset", "bool", "N/A"},
        ]
      },
      %{
        title: "AGM Battery",
        items: [
          # Read
          {"Actual Voltage", "GVL_Visu.stVisu_bmsAGM_read.Ubat", "V", "N/A"},
          {"Actual current", "GVL_Visu.stVisu_bmsAGM_read.Ibat", "A", "N/A"},
          {"Actual power", "GVL_Visu.stVisu_bmsAGM_read.Pbat", "W", "N/A"},
          {"SOC", "GVL_Visu.stVisu_bmsAGM_read.SOC", "%", "N/A"},
          {"Balance of baterry ", "GVL_Visu.stVisu_bmsAGM_read.Balance", "%", "N/A"},
          {"Max. Temp. cells", "GVL_Visu.stVisu_bmsAGM_read.Tmax", "%", "N/A"},
          {"Delta U cells", "GVL_Visu.stVisu_bmsAGM_read.Udiff", "mV", "N/A"},
          {"Delta impedance cells", "GVL_Visu.stVisu_bmsAGM_read.Impdiff", "mohm", "N/A"},
          {"Baterry status", "GVL_Visu.stVisu_bmsAGM_read.Status", "", "N/A"},
          {"Baterry alarms", "GVL_Visu.stVisu_bmsAGM_read.Alarms", "", "N/A"},
          {"Baterry on/off [true/false]", "GVL_Visu.stVisu_bmsAGM_read.BatState", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_bmsAGM_read.Connection", "", "N/A"},

          # Set
          {"Switch Baterry on/off [true/false]", "GVL_Visu.stVisu_bmsAGM_set.bONOFF", "bool", "N/A"},
          {"Reset Baterry [Rising/Falling edge]", "GVL_Visu.stVisu_bmsAGM_set.bReset", "bool", "N/A"},
        ]
      },
      %{
        title: "SCAP Battery",
        items: [
          # Read
          {"Actual Voltage", "GVL_Visu.stVisu_bmsSCAP_read.Ubat", "V", "N/A"},
          {"Actual current", "GVL_Visu.stVisu_bmsSCAP_read.Ibat", "A", "N/A"},
          {"Actual power", "GVL_Visu.stVisu_bmsSCAP_read.Pbat", "W", "N/A"},
          {"SOC", "GVL_Visu.stVisu_bmsSCAP_read.SOC", "%", "N/A"},
          {"SOH", "GVL_Visu.stVisu_bmsSCAP_read.SOH", "%", "N/A"},
          {"Delta U cells", "GVL_Visu.stVisu_bmsSCAP_read.Udiff", "mV", "N/A"},
          {"Max. Temp. cells", "GVL_Visu.stVisu_bmsSCAP_read.Tmax", "%", "N/A"},
          {"Baterry status", "GVL_Visu.stVisu_bmsSCAP_read.Status", "", "N/A"},
          {"Baterry alarms", "GVL_Visu.stVisu_bmsSCAP_read.Alarms", "", "N/A"},
          {"Baterry on/off [true/false]", "GVL_Visu.stVisu_bmsSCAP_read.BatState", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_bmsSCAP_read.Connection", "", "N/A"},

          # Set
          {"Switch Baterry on/off [true/false]", "GVL_Visu.stVisu_bmsSCAP_set.bONOFF", "bool", "N/A"},
          {"Reset Baterry [Rising/Falling edge]", "GVL_Visu.stVisu_bmsSCAP_set.bReset", "bool", "N/A"},
        ]
      },
      %{
        title: "RG 1",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "RG 2",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Converter 1",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Converter 2",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Converter 3",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Converter 4",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "DC Converter 5",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "AC/DC Converter",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "EV Charger",
        items: [
          {"Prędkość wiatru", "Main.WindSpeed", "m/s", "N/A"},
          {"Śr. prędkość wiatru", "Main.AvWindSpeed", "m/s", "N/A"},
          {"Kierunek wiatru", "Main.WindDirection", "°", "N/A"},
          {"Temperatura", "Main.Temperature", "°C", "N/A"}
        ]
      },
      %{
        title: "Self Power",
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
