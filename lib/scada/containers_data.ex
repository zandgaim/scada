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
          {"Switch meter [true/false]", "GVL_Visu.stVisu_MeasWeather_set.bONOFF", "bool", ""}
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
          {"Switch Baterry on/off [true/false]", "GVL_Visu.stVisu_bmsLIION_set.bONOFF", "bool",
           "N/A"},
          {"Reset Baterry [Rising/Falling edge]", "GVL_Visu.stVisu_bmsLIION_set.bReset", "bool",
           "N/A"}
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
          {"Switch Baterry on/off [true/false]", "GVL_Visu.stVisu_bmsAGM_set.bONOFF", "bool",
           "N/A"},
          {"Reset Baterry [Rising/Falling edge]", "GVL_Visu.stVisu_bmsAGM_set.bReset", "bool",
           "N/A"}
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
          {"Switch Baterry on/off [true/false]", "GVL_Visu.stVisu_bmsSCAP_set.bONOFF", "bool",
           "N/A"},
          {"Reset Baterry [Rising/Falling edge]", "GVL_Visu.stVisu_bmsSCAP_set.bReset", "bool",
           "N/A"}
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
          # Read
          {"Daily Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_HV_read.EPday", "kWh",
           "N/A"},
          {"Total Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_HV_read.EPtotal", "kWh",
           "N/A"},
          {"Voltage RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_HV_read.Urms", "V", "N/A"},
          {"Current RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_HV_read.Irms", "A", "N/A"},
          {"Active Power RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_HV_read.Prms", "W",
           "N/A"},
          {"Meter status", "GVL_Visu.stVisu_MeterDC_DAB_EV_HV_read.Status", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_EV_HV_read.Connection", "",
           "N/A"},

          # Set
          {"Switch meter on/off [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_EV_HV_set.bONOFF",
           "bool", "N/A"},
          {"Reset daily energy [true/false]",
           "GVL_Visu.stVisu_MeterDC_DAB_EV_HV_set.bResetDailyEnergy", "bool", "N/A"},

          # Read
          {"DC link voltage", "GVL_Visu.stVisu_DAB_EV_read.UHV", "V", "N/A"},
          {"Load voltage", "GVL_Visu.stVisu_DAB_EV_read.ULV", "V", "N/A"},
          {"DC link current", "GVL_Visu.stVisu_DAB_EV_read.IHV", "A", "N/A"},
          {"Load current", "GVL_Visu.stVisu_DAB_EV_read.ILV", "A", "N/A"},
          {"Output active power load", "GVL_Visu.stVisu_DAB_EV_read.Ptotal", "W", "N/A"},
          {"Max. temperature", "GVL_Visu.stVisu_DAB_EV_read.TMax", "°C", "N/A"},
          {"Max. MOSFET temperature", "GVL_Visu.stVisu_DAB_EV_read.TMosfet", "°C", "N/A"},
          {"Max. Termistor temperature", "GVL_Visu.stVisu_DAB_EV_read.TTermistor", "°C", "N/A"},
          {"Converter status", "GVL_Visu.stVisu_DAB_EV_read.Status", "", "N/A"},
          {"Converter alarms", "GVL_Visu.stVisu_DAB_EV_read.Alarms", "", "N/A"},
          {"Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_EV_read.ConvState", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_DAB_EV_read.Connection", "", "N/A"},
          {"Data mismatch with the converter", "GVL_Visu.stVisu_DAB_EV_read.ErrorSaveParam", "",
           "N/A"},

          # Set
          {"Switch Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_EV_set.bONOFF", "bool",
           "N/A"},
          {"Reset Converter [Rising/Falling edge]", "GVL_Visu.stVisu_DAB_EV_set.bReset", "bool",
           "N/A"},
          {"Max DC link voltage", "GVL_Visu.stVisu_DAB_EV_set.rUHVmax", "V", "N/A"},
          {"Max Load voltage", "GVL_Visu.stVisu_DAB_EV_set.rULVmax", "V", "N/A"},
          {"Min DC link voltage", "GVL_Visu.stVisu_DAB_EV_set.rUHVmin", "V", "N/A"},
          {"Min Load voltage", "GVL_Visu.stVisu_DAB_EV_set.rULVmin", "V", "N/A"},
          {"Max DC link current", "GVL_Visu.stVisu_DAB_EV_set.rIHVmax", "A", "N/A"},
          {"Max Load current", "GVL_Visu.stVisu_DAB_EV_set.rILVmax", "A", "N/A"},
          {"Set Converter power", "GVL_Visu.stVisu_DAB_EV_set.rPowerSet", "W", "N/A"},
          {"Device IP Address", "GVL_Visu.stVisu_DAB_EV_set.IP_address", "string", "N/A"},
          {"Device ID Number", "GVL_Visu.stVisu_DAB_EV_set.ID_number", "int", "N/A"}
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
          # Read
          {"Daily Energy Measurement", "GVL_Visu.stVisu_MeterDC_AFE_read.EPday", "kWh", "N/A"},
          {"Total Energy Measurement", "GVL_Visu.stVisu_MeterDC_AFE_read.EPtotal", "kWh", "N/A"},
          {"Voltage RMS Measurement", "GVL_Visu.stVisu_MeterDC_AFE_read.Urms", "V", "N/A"},
          {"Current RMS Measurement", "GVL_Visu.stVisu_MeterDC_AFE_read.Irms", "A", "N/A"},
          {"Active Power RMS Measurement", "GVL_Visu.stVisu_MeterDC_AFE_read.Prms", "W", "N/A"},
          {"Meter status", "GVL_Visu.stVisu_MeterDC_AFE_read.Status", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_MeterDC_AFE_read.Connection", "", "N/A"},

          # Set
          {"Switch meter on/off [true/false]", "GVL_Visu.stVisu_MeterDC_AFE_set.bONOFF", "bool",
           "N/A"},
          {"Reset daily energy [true/false]", "GVL_Visu.stVisu_MeterDC_AFE_set.bResetDailyEnergy",
           "bool", "N/A"},

          # Read
          {"A-phase voltage", "GVL_Visu.stVisu_AFE_read.Varms", "V", "N/A"},
          {"B-phase voltage ", "GVL_Visu.stVisu_AFE_read.Vbrms", "V", "N/A"},
          {"C-phase voltage", "GVL_Visu.stVisu_AFE_read.Vcrms", "V", "N/A"},
          {"A-phase current", "GVL_Visu.stVisu_AFE_read.Iarms", "A", "N/A"},
          {"B-phase current", "GVL_Visu.stVisu_AFE_read.Ibrms", "A", "N/A"},
          {"C-phase current", "GVL_Visu.stVisu_AFE_read.Icrms", "A", "N/A"},
          {"Output active power", "GVL_Visu.stVisu_AFE_read.Pac", "w", "N/A"},
          {"Output reactive power", "GVL_Visu.stVisu_AFE_read.Qac", "var", "N/A"},
          {"On-Grid frequency", "GVL_Visu.stVisu_AFE_read.Fongrid", "Hz", "N/A"},
          {"Max. Inverter heat sink temperature", "GVL_Visu.stVisu_AFE_read.Tempheat", "°C",
           "N/A"},
          {"Inverter status", "GVL_Visu.stVisu_AFE_read.Status", "", "N/A"},
          {"Inverter alarms", "GVL_Visu.stVisu_AFE_read.Alarms", "", "N/A"},
          {"Inverter on/off [true/false]", "GVL_Visu.stVisu_AFE_read.InvState", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_AFE_read.Connection", "", "N/A"},
          {"Data mismatch with the converter", "GVL_Visu.stVisu_AFE_read.ErrorSaveParam", "",
           "N/A"},

          # Set
          {"Switch Inverter on/off", "GVL_Visu.stVisu_AFE_set.bONOFF", "bool", "N/A"},
          {"Reset Inverter", "GVL_Visu.stVisu_AFE_set.bReset", "bool", "N/A"},
          {"OC AC protection value", "GVL_Visu.stVisu_AFE_set.rAlarm_I_conv", "A", "N/A"},
          {"Undervoltage DC protection value", "GVL_Visu.stVisu_AFE_set.rAlarm_U_dc_L", "V",
           "N/A"},
          {"Overvoltage DC protection value", "GVL_Visu.stVisu_AFE_set.rAlarm_U_dc_H", "V",
           "N/A"},
          {"Undervoltage AC protection value", "GVL_Visu.stVisu_AFE_set.rAlarm_U_grid_L", "V",
           "N/A"},
          {"Overvoltage AC protection value", "GVL_Visu.stVisu_AFE_set.rAlarm_U_grid_H", "V",
           "N/A"},
          {"Overtemperature value", "GVL_Visu.stVisu_AFE_set.rAlarm_Temperature", "°C", "N/A"},
          {"Reference active power value", "GVL_Visu.stVisu_AFE_set.rPref", "W", "N/A"},
          {"Reference reactive power value", "GVL_Visu.stVisu_AFE_set.rQref", "var", "N/A"},
          {"Address IP device", "GVL_Visu.stVisu_AFE_set.IP_address", "string", "N/A"}
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
