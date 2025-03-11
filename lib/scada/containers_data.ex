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
          # Read
          {"Total system power", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Ptotal", "W", "N/A"},
          {"Import kWh/day", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Pdayimport", "kWh", "N/A"},
          {"Export kWh/day", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Pdayexport", "kWh", "N/A"},
          {"Import kWh/total", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Pimport", "kWh", "N/A"},
          {"Export kWh/total", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Pexport", "kWh", "N/A"},
          {"Frequency of supply voltages", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Fgrid", "kWh", "N/A"},
          {"Total system power factor", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Pfactor", "", "N/A"},
          {"Phase 1 active power", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.P1rms", "W", "N/A"},
          {"Phase 2 active power", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.P2rms", "W", "N/A"},
          {"Phase 3 active power", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.P3rms", "W", "N/A"},
          {"Total system VAr", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Qtotal", "VAr", "N/A"},
          {"Total system volt amps", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Stotal", "VA", "N/A"},
          {"Phase 1 current", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.I1rms", "A", "N/A"},
          {"Phase 2 current", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.I2rms", "A", "N/A"},
          {"Phase 3 current", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.I3rms", "A", "N/A"},
          {"Phase 1 line to neutral volts", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.U1Nrms", "V", "N/A"},
          {"Phase 2 line to neutral volts", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.U2Nrms", "V", "N/A"},
          {"Phase 3 line to neutral volts", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.U3Nrms", "V", "N/A"},
          {"Import VArh/total", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Qimport", "kVArh", "N/A"},
          {"Export VArh/total", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Qexport", "kVArh", "N/A"},
          {"Meter status", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Status", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_MeterAC_NR30IoT_read.Connection", "", "N/A"},

          # Set
          {"Switch meter on/off [true/false]", "GVL_Visu.stVisu_MeterAC_NR30IoT_set.bONOFF", "bool", "N/A"},
          {"Reset daily energy [true/false]", "GVL_Visu.stVisu_MeterAC_NR30IoT_set.bResetDailyEnergy", "bool", "N/A"},

          # Read
          {"Total system power", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Ptotal", "W", "N/A"},
          {"Import kWh/day", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Pdayimport", "kWh", "N/A"},
          {"Export kWh/day", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Pdayexport", "kWh", "N/A"},
          {"Import kWh/total", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Pimport", "kWh", "N/A"},
          {"Export kWh/total", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Pexport", "kWh", "N/A"},
          {"Frequency of supply voltages", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Fgrid", "kWh", "N/A"},
          {"Total system power factor", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Pfactor", "", "N/A"},
          {"Phase 1 active power", "GVL_Visu.stVisu_stMeterAC_NMID30_read.P1rms", "W", "N/A"},
          {"Phase 2 active power", "GVL_Visu.stVisu_stMeterAC_NMID30_read.P2rms", "W", "N/A"},
          {"Phase 3 active power", "GVL_Visu.stVisu_stMeterAC_NMID30_read.P3rms", "W", "N/A"},
          {"Total system VAr", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Qtotal", "VAr", "N/A"},
          {"Total system volt amps", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Stotal", "VA", "N/A"},
          {"Phase 1 current", "GVL_Visu.stVisu_stMeterAC_NMID30_read.I1rms", "A", "N/A"},
          {"Phase 2 current", "GVL_Visu.stVisu_stMeterAC_NMID30_read.I2rms", "A", "N/A"},
          {"Phase 3 current", "GVL_Visu.stVisu_stMeterAC_NMID30_read.I3rms", "A", "N/A"},
          {"Phase 1 line to neutral volts", "GVL_Visu.stVisu_stMeterAC_NMID30_read.U1Nrms", "V", "N/A"},
          {"Phase 2 line to neutral volts", "GVL_Visu.stVisu_stMeterAC_NMID30_read.U2Nrms", "V", "N/A"},
          {"Phase 3 line to neutral volts", "GVL_Visu.stVisu_stMeterAC_NMID30_read.U3Nrms", "V", "N/A"},
          {"Import VArh/total", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Qimport", "kVArh", "N/A"},
          {"Export VArh/total", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Qexport", "kVArh", "N/A"},
          {"Meter status", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Status", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_stMeterAC_NMID30_read.Connection", "", "N/A"},

          # Set
          {"Switch meter on/off [true/false]", "GVL_Visu.stVisu_stMeterAC_NMID30_set.bONOFF", "bool", "N/A"},
          {"Reset daily energy [true/false]", "GVL_Visu.stVisu_stMeterAC_NMID30_set.bResetDailyEnergy", "bool", "N/A"}
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
          # Read
          {"Power Breaker Status on Inverter AFE Side", "GVL_Visu.stVisu_RGx_read.NSX250B_AFE", "", "N/A"},
          {"Power Breaker Status on Converter PV Side", "GVL_Visu.stVisu_RGx_read.NSX250B_PV", "", "N/A"},
          {"Power Breaker Status on Converter LIION Side", "GVL_Visu.stVisu_RGx_read.NSX250B_LIION", "", "N/A"},
          {"Circuit Breaker Status on the KontrolaDostepu", "GVL_Visu.stVisu_RGx_read.KontrolaDostepu", "", "N/A"},
          {"Circuit Breaker Status on the ObwodGniad1f", "GVL_Visu.stVisu_RGx_read.ObwodGniad1f", "", "N/A"},
          {"Circuit Breaker Status on the Wentylator1", "GVL_Visu.stVisu_RGx_read.Wentylator1", "", "N/A"},
          {"Circuit Breaker Status on the Wentylator2", "GVL_Visu.stVisu_RGx_read.Wentylator2", "", "N/A"},
          {"Circuit Breaker Status on the Wentylator3", "GVL_Visu.stVisu_RGx_read.Wentylator3", "", "N/A"},
          {"Circuit Breaker Status on the Wentylator4", "GVL_Visu.stVisu_RGx_read.Wentylator4", "", "N/A"},
          {"Circuit Breaker Status on the Klimatyzacja", "GVL_Visu.stVisu_RGx_read.Klimatyzacja", "", "N/A"},
          {"Circuit Breaker Status on the Rezerwa1_AC", "GVL_Visu.stVisu_RGx_read.Rezerwa1_AC", "", "N/A"},
          {"Circuit Breaker Status on the Rezerwa2_AC", "GVL_Visu.stVisu_RGx_read.Rezerwa2_AC", "", "N/A"},
          {"Fan speed in RK1", "GVL_Visu.stVisu_RGx_read.rFan_percent1", "", "N/A"},
          {"Fan speed in RK2", "GVL_Visu.stVisu_RGx_read.rFan_percent2", "", "N/A"},
          {"Fan speed in RK3", "GVL_Visu.stVisu_RGx_read.rFan_percent3", "", "N/A"},
          {"Fan speed in RK4", "GVL_Visu.stVisu_RGx_read.rFan_percent4", "", "N/A"},

          # Set
          {"Change Circuit Breaker Switch Status on the KontrolaDostepu", "GVL_Visu.stVisu_RGx_set.KontrolaDostepu", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the ObwodGniad1f", "GVL_Visu.stVisu_RGx_set.ObwodGniad1f", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Wentylator1", "GVL_Visu.stVisu_RGx_set.Wentylator1", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Wentylator2", "GVL_Visu.stVisu_RGx_set.Wentylator2", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Wentylator3", "GVL_Visu.stVisu_RGx_set.Wentylator3", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Wentylator4", "GVL_Visu.stVisu_RGx_set.Wentylator4", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Klimatyzacja", "GVL_Visu.stVisu_RGx_set.Klimatyzacja", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Rezerwa1_AC", "GVL_Visu.stVisu_RGx_set.Rezerwa1_AC", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Rezerwa2_AC", "GVL_Visu.stVisu_RGx_set.Rezerwa2_AC", "bool", "N/A"},
          {"Force Fan speed in RK1", "GVL_Visu.stVisu_RGx_set.rFan_percent1", "int", "N/A"},
          {"Force Fan speed in RK2", "GVL_Visu.stVisu_RGx_set.rFan_percent2", "int", "N/A"},
          {"Force Fan speed in RK3", "GVL_Visu.stVisu_RGx_set.rFan_percent3", "int", "N/A"},
          {"Force Fan speed in RK4", "GVL_Visu.stVisu_RGx_set.rFan_percent4", "int", "N/A"}
        ]
      },
      %{
        title: "RG 2",
        items: [
          # Read
          {"Power Breaker Status on Converter EV Side", "GVL_Visu.stVisu_RGx_read.NSX250B_EV", "", "N/A"},
          {"Power Breaker Status on Converter SCAP Side", "GVL_Visu.stVisu_RGx_read.NSX250B_SCAP", "", "N/A"},
          {"Power Breaker Status on Converter AGM Side", "GVL_Visu.stVisu_RGx_read.NSX250B_AGM", "", "N/A"},
          {"Power Breaker Status on Converter LOAD Side", "GVL_Visu.stVisu_RGx_read.NSX250B_LOAD", "", "N/A"},
          {"Circuit Breaker Status on the Rezerwa2_AC", "GVL_Visu.stVisu_RGx_read.ZasilaczeBMS1", "", "N/A"},
          {"Circuit Breaker Status on the Rezerwa2_AC", "GVL_Visu.stVisu_RGx_read.ZasilaczeBMS2", "", "N/A"},
          {"Circuit Breaker Status on the ZasilaczeBMS3", "GVL_Visu.stVisu_RGx_read.ZasilaczeBMS3", "", "N/A"},
          {"Circuit Breaker Status on the ZasilaczeBMS4", "GVL_Visu.stVisu_RGx_read.ZasilaczeBMS4", "", "N/A"},
          {"Circuit Breaker Status on the Oswietlenie", "GVL_Visu.stVisu_RGx_read.Oswietlenie", "", "N/A"},
          {"Circuit Breaker Status on the Rezerwa24V_1", "GVL_Visu.stVisu_RGx_read.Rezerwa24V_1", "", "N/A"},
          {"Circuit Breaker Status on the Rezerwa24V_2", "GVL_Visu.stVisu_RGx_read.Rezerwa24V_2", "", "N/A"},
          {"Circuit Breaker Status on the Rezerwa24V_3", "GVL_Visu.stVisu_RGx_read.Rezerwa24V_3", "", "N/A"},
          {"Circuit Breaker Status on the RezerwaDC", "GVL_Visu.stVisu_RGx_read.RezerwaDC", "", "N/A"},
          {"Circuit Breaker Status on the Supply_AGM_24V", "GVL_Visu.stVisu_RGx_read.Supply_AGM_24V", "", "N/A"},
          {"Circuit Breaker Status on the Supply_LIION_24V", "GVL_Visu.stVisu_RGx_read.Supply_LIION_24V", "", "N/A"},
          {"Circuit Breaker Status on the Supply_BUS_24V", "GVL_Visu.stVisu_RGx_read.Supply_BUS_24V", "", "N/A"},
          {"Circuit Breaker Status on the Zasilanie760V_24V", "GVL_Visu.stVisu_RGx_read.Zasilanie760V_24V", "", "N/A"},
          {"Temperature in RK0", "GVL_Visu.stVisu_RGx_read.rRGx_Temperature1", "", "N/A"},
          {"Temperature in RK1", "GVL_Visu.stVisu_RGx_read.rRGx_Temperature2", "", "N/A"},
          {"Temperature in RK2", "GVL_Visu.stVisu_RGx_read.rRGx_Temperature3", "", "N/A"},
          {"Temperature in RK3", "GVL_Visu.stVisu_RGx_read.rRGx_Temperature4", "", "N/A"},

          # Set
          {"Change Circuit Breaker Switch Status on the Rezerwa2_AC", "GVL_Visu.stVisu_RGx_set.ZasilaczeBMS1", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Rezerwa2_AC", "GVL_Visu.stVisu_RGx_set.ZasilaczeBMS2", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the ZasilaczeBMS3", "GVL_Visu.stVisu_RGx_set.ZasilaczeBMS3", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the ZasilaczeBMS4", "GVL_Visu.stVisu_RGx_set.ZasilaczeBMS4", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Oswietlenie", "GVL_Visu.stVisu_RGx_set.Oswietlenie", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Rezerwa24V_1", "GVL_Visu.stVisu_RGx_set.Rezerwa24V_1", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Rezerwa24V_2", "GVL_Visu.stVisu_RGx_set.Rezerwa24V_2", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Rezerwa24V_3", "GVL_Visu.stVisu_RGx_set.Rezerwa24V_3", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the RezerwaDC", "GVL_Visu.stVisu_RGx_set.RezerwaDC", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Supply_AGM_24V", "GVL_Visu.stVisu_RGx_set.Supply_AGM_24V", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Supply_LIION_24V", "GVL_Visu.stVisu_RGx_set.Supply_LIION_24V", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Supply_BUS_24V", "GVL_Visu.stVisu_RGx_set.Supply_BUS_24V", "bool", "N/A"},
          {"Change Circuit Breaker Switch Status on the Zasilanie760V_24V", "GVL_Visu.stVisu_RGx_set.Zasilanie760V_24V", "bool", "N/A"}
        ]
      },
      %{
        # EV
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
        # PV
        title: "DC Converter 2",
        items: [
          # Read
          {"Daily Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_PV_read.EPday", "kWh", "N/A"},
          {"Total Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_PV_read.EPtotal", "kWh",
           "N/A"},
          {"Voltage RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_PV_read.Urms", "V", "N/A"},
          {"Current RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_PV_read.Irms", "A", "N/A"},
          {"Active Power RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_PV_read.Prms", "", "N/A"},
          {"Meter status", "GVL_Visu.stVisu_MeterDC_DAB_PV_read.Status", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_PV_read.Connection", "",
           "N/A"},

          # Set
          {"Switch meter on/off [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_PV_set.bONOFF",
           "bool", "N/A"},
          {"Reset daily energy [true/false]",
           "GVL_Visu.stVisu_MeterDC_DAB_PV_set.bResetDailyEnergy", "bool", "N/A"},

          # Read
          {"DC link voltage", "GVL_Visu.stVisu_DAB_PV_read.UHV", "V", "N/A"},
          {"Load voltage", "GVL_Visu.stVisu_DAB_PV_read.ULV", "V", "N/A"},
          {"DC link current", "GVL_Visu.stVisu_DAB_PV_read.IHV", "A", "N/A"},
          {"Load current", "GVL_Visu.stVisu_DAB_PV_read.ILV", "A", "N/A"},
          {"Output active power load", "GVL_Visu.stVisu_DAB_PV_read.Ptotal", "W", "N/A"},
          {"Max. temperature", "GVL_Visu.stVisu_DAB_PV_read.TMax", "°C", "N/A"},
          {"Max. MOSFET temperature", "GVL_Visu.stVisu_DAB_PV_read.TMosfet", "°C", "N/A"},
          {"Max. Termistor temperature", "GVL_Visu.stVisu_DAB_PV_read.TTermistor", "°C", "N/A"},
          {"Converter status", "GVL_Visu.stVisu_DAB_PV_read.Status", "", "N/A"},
          {"Converter alarms", "GVL_Visu.stVisu_DAB_PV_read.Alarms", "", "N/A"},
          {"Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_PV_read.ConvState", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_DAB_PV_read.Connection", "", "N/A"},
          {"Data mismatch with the converter", "GVL_Visu.stVisu_DAB_PV_read.ErrorSaveParam", "",
           "N/A"},

          # Set
          {"Switch Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_PV_set.bONOFF", "",
           "N/A"},
          {"Reset Converter [Rising/Falling edge]", "GVL_Visu.stVisu_DAB_PV_set.bReset", "",
           "N/A"},
          {"Maksymalne napięcie obwodu pośredniczącego DC", "GVL_Visu.stVisu_DAB_PV_set.rUHVmax",
           "V", "N/A"},
          {"Maksymalne napięcie odbiornika", "GVL_Visu.stVisu_DAB_PV_set.rULVmax", "V", "N/A"},
          {"Minimalne napięcie obwodu pośredniczącego DC", "GVL_Visu.stVisu_DAB_PV_set.rUHVmin",
           "V", "N/A"},
          {"Minimalne napięcie odbiornika", "GVL_Visu.stVisu_DAB_PV_set.rULVmin", "V", "N/A"},
          {"Maksymalny prąd obwodu pośredniczącego DC", "GVL_Visu.stVisu_DAB_PV_set.rIHVmax", "A",
           "N/A"},
          {"Maksymalny prąd odbiornika", "GVL_Visu.stVisu_DAB_PV_set.rILVmax", "A", "N/A"},
          {"Set the power of the converter", "GVL_Visu.stVisu_DAB_PV_set.rPowerSet", "", "N/A"},
          {"Address IP device '10.0.10.x'", "GVL_Visu.stVisu_DAB_PV_set.IP_address", "string",
           "N/A"},
          {"Number ID device", "GVL_Visu.stVisu_DAB_PV_set.ID_number", "int", "N/A"}
        ]
      },
      %{
        # li-ion
        title: "DC Converter 3",
        items: [
          # Read
          {"Daily Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_LiIon_read.EPday", "kWh",
           "N/A"},
          {"Total Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_LiIon_read.EPtotal", "kWh",
           "N/A"},
          {"Voltage RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_LiIon_read.Urms", "V", "N/A"},
          {"Current RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_LiIon_read.Irms", "A", "N/A"},
          {"Active Power RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_LiIon_read.Prms", "W",
           "N/A"},
          {"Meter status", "GVL_Visu.stVisu_MeterDC_DAB_LiIon_read.Status", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_LiIon_read.Connection", "",
           "N/A"},

          # Set
          {"Switch meter on/off [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_LiIon_set.bONOFF",
           "bool", "N/A"},
          {"Reset daily energy [true/false]",
           "GVL_Visu.stVisu_MeterDC_DAB_LiIon_set.bResetDailyEnergy", "bool", "N/A"},

          # Read
          {"DC link voltage", "GVL_Visu.stVisu_DAB_LiIon_read.UHV", "V", "N/A"},
          {"Load voltage", "GVL_Visu.stVisu_DAB_LiIon_read.ULV", "V", "N/A"},
          {"DC link current", "GVL_Visu.stVisu_DAB_LiIon_read.IHV", "A", "N/A"},
          {"Load current", "GVL_Visu.stVisu_DAB_LiIon_read.ILV", "A", "N/A"},
          {"Output active power load", "GVL_Visu.stVisu_DAB_LiIon_read.Ptotal", "W", "N/A"},
          {"Max. temperature", "GVL_Visu.stVisu_DAB_LiIon_read.TMax", "°C", "N/A"},
          {"Max. MOSFET temperature", "GVL_Visu.stVisu_DAB_LiIon_read.TMosfet", "°C", "N/A"},
          {"Max. Termistor temperature", "GVL_Visu.stVisu_DAB_LiIon_read.TTermistor", "°C",
           "N/A"},
          {"Converter status", "GVL_Visu.stVisu_DAB_LiIon_read.Status", "", "N/A"},
          {"Converter alarms", "GVL_Visu.stVisu_DAB_LiIon_read.Alarms", "", "N/A"},
          {"Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_LiIon_read.ConvState", "",
           "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_DAB_LiIon_read.Connection", "", "N/A"},
          {"Data mismatch with the converter", "GVL_Visu.stVisu_DAB_LiIon_read.ErrorSaveParam",
           "", "N/A"},

          # # Set
          {" Switch Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_LiIon_set.bONOFF",
           "bool", "N/A"},
          {"Reset Converter [Rising/Falling edge]", "GVL_Visu.stVisu_DAB_LiIon_set.bReset",
           "bool", "N/A"},
          {"Maksymalne napięcie obwodu pośredniczącego DC",
           "GVL_Visu.stVisu_DAB_LiIon_set.rUHVmax", "V", "N/A"},
          {"Maksymalne napięcie odbiornika", "GVL_Visu.stVisu_DAB_LiIon_set.rULVmax", "V", "N/A"},
          {"Minimalne napięcie obwodu pośredniczącego DC",
           "GVL_Visu.stVisu_DAB_LiIon_set.rUHVmin", "V", "N/A"},
          {"Minimalne napięcie odbiornika", "GVL_Visu.stVisu_DAB_LiIon_set.rULVmin", "V", "N/A"},
          {"Maksymalny prąd obwodu pośredniczącego DC", "GVL_Visu.stVisu_DAB_LiIon_set.rIHVmax",
           "A", "N/A"},
          {"Maksymalny prąd odbiornika", "GVL_Visu.stVisu_DAB_LiIon_set.rILVmax", "A", "N/A"},
          {"Set the power of the converter", "GVL_Visu.stVisu_DAB_LiIon_set.rPowerSet", "",
           "N/A"},
          {"Address IP device '10.0.10.x'", "GVL_Visu.stVisu_DAB_LiIon_set.IP_address", "string",
           "N/A"},
          {"Number ID device", "GVL_Visu.stVisu_DAB_LiIon_set.ID_number", "int", "N/A"}
        ]
      },
      %{
        # AGM
        title: "DC Converter 4",
        items: [
          # Read
          {"Daily Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_AGM_read.EPday", "kWh",
           "N/A"},
          {"Total Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_AGM_read.EPtotal", "kWh",
           "N/A"},
          {"Voltage RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_AGM_read.Urms", "V", "N/A"},
          {"Current RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_AGM_read.Irms", "A", "N/A"},
          {"Active Power RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_AGM_read.Prms", "W",
           "N/A"},
          {"Meter status", "GVL_Visu.stVisu_MeterDC_DAB_AGM_read.Status", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_AGM_read.Connection", "",
           "N/A"},

          # Set
          {"Switch meter on/off [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_AGM_set.bONOFF",
           "bool", "N/A"},
          {"Reset daily energy [true/false]",
           "GVL_Visu.stVisu_MeterDC_DAB_AGM_set.bResetDailyEnergy", "bool", "N/A"},

          # Read
          {"DC link voltage", "GVL_Visu.stVisu_DAB_AGM_read.UHV", "V", "N/A"},
          {"Load voltage", "GVL_Visu.stVisu_DAB_AGM_read.ULV", "V", "N/A"},
          {"DC link current", "GVL_Visu.stVisu_DAB_AGM_read.IHV", "A", "N/A"},
          {"Load current", "GVL_Visu.stVisu_DAB_AGM_read.ILV", "A", "N/A"},
          {"Output active power load", "GVL_Visu.stVisu_DAB_AGM_read.Ptotal", "W", "N/A"},
          {"Max. temperature", "GVL_Visu.stVisu_DAB_AGM_read.TMax", "°C", "N/A"},
          {"Max. MOSFET temperature", "GVL_Visu.stVisu_DAB_AGM_read.TMosfet", "°C", "N/A"},
          {"Max. Termistor temperature", "GVL_Visu.stVisu_DAB_AGM_read.TTermistor", "°C", "N/A"},
          {"Converter status", "GVL_Visu.stVisu_DAB_AGM_read.Status", "", "N/A"},
          {"Converter alarms", "GVL_Visu.stVisu_DAB_AGM_read.Alarms", "", "N/A"},
          {"Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_AGM_read.ConvState", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_DAB_AGM_read.Connection", "", "N/A"},
          {"Data mismatch with the converter", "GVL_Visu.stVisu_DAB_AGM_read.ErrorSaveParam", "",
           "N/A"},

          # Set
          {"Switch Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_AGM_set.bONOFF", "bool",
           "N/A"},
          {"Reset Converter [Rising/Falling edge]", "GVL_Visu.stVisu_DAB_AGM_set.bReset", "bool",
           "N/A"},
          {"Maksymalne napięcie obwodu pośredniczącego DC", "GVL_Visu.stVisu_DAB_AGM_set.rUHVmax",
           "V", "N/A"},
          {"Maksymalne napięcie odbiornika", "GVL_Visu.stVisu_DAB_AGM_set.rULVmax", "V", "N/A"},
          {"Minimalne napięcie obwodu pośredniczącego DC", "GVL_Visu.stVisu_DAB_AGM_set.rUHVmin",
           "V", "N/A"},
          {"Minimalne napięcie odbiornika", "GVL_Visu.stVisu_DAB_AGM_set.rULVmin", "V", "N/A"},
          {"Maksymalny prąd obwodu pośredniczącego DC", "GVL_Visu.stVisu_DAB_AGM_set.rIHVmax",
           "A", "N/A"},
          {"Maksymalny prąd odbiornika", "GVL_Visu.stVisu_DAB_AGM_set.rILVmax", "A", "N/A"},
          {"Set the power of the converter", "GVL_Visu.stVisu_DAB_AGM_set.rPowerSet", "", "N/A"},
          {"Address IP device '10.0.10.x'", "GVL_Visu.stVisu_DAB_AGM_set.IP_address", "string",
           "N/A"},
          {"Number ID device", "GVL_Visu.stVisu_DAB_AGM_set.ID_number", "int", "N/A"}
        ]
      },
      %{
        # SCAP
        title: "DC Converter 5",
        items: [
          # Read
          {"Daily Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_SCAP_read.EPday", "kWh",
           "N/A"},
          {"Total Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_SCAP_read.EPtotal", "kWh",
           "N/A"},
          {"Voltage RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_SCAP_read.Urms", "V", "N/A"},
          {"Current RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_SCAP_read.Irms", "A", "N/A"},
          {"Active Power RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_SCAP_read.Prms", "W",
           "N/A"},
          {"Meter status", "GVL_Visu.stVisu_MeterDC_DAB_SCAP_read.Status", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_SCAP_read.Connection", "",
           "N/A"},

          # Set
          {"Switch meter on/off [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_SCAP_set.bONOFF",
           "bool", "N/A"},
          {"Reset daily energy [true/false]",
           "GVL_Visu.stVisu_MeterDC_DAB_SCAP_set.bResetDailyEnergy", "bool", "N/A"},

          # Read
          {"DC link voltage", "GVL_Visu.stVisu_DAB_SCAP_read.UHV", "V", "N/A"},
          {"Load voltage", "GVL_Visu.stVisu_DAB_SCAP_read.ULV", "V", "N/A"},
          {"DC link current", "GVL_Visu.stVisu_DAB_SCAP_read.IHV", "A", "N/A"},
          {"Load current", "GVL_Visu.stVisu_DAB_SCAP_read.ILV", "A", "N/A"},
          {"Output active power load", "GVL_Visu.stVisu_DAB_SCAP_read.Ptotal", "W", "N/A"},
          {"Max. temperature", "GVL_Visu.stVisu_DAB_SCAP_read.TMax", "°C", "N/A"},
          {"Max. MOSFET temperature", "GVL_Visu.stVisu_DAB_SCAP_read.TMosfet", "°C", "N/A"},
          {"Max. Termistor temperatur", "GVL_Visu.stVisu_DAB_SCAP_read.TTermistor", "°C", "N/A"},
          {"Converter status", "GVL_Visu.stVisu_DAB_SCAP_read.Status", "", "N/A"},
          {"Converter alarms", "GVL_Visu.stVisu_DAB_SCAP_read.Alarms", "", "N/A"},
          {"Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_SCAP_read.ConvState", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_DAB_SCAP_read.Connection", "", "N/A"},
          {"Data mismatch with the converter", "GVL_Visu.stVisu_DAB_SCAP_read.ErrorSaveParam",
           "1111111111111", "N/A"},

          # Set
          {"Switch Converter on/off [true/false]", "GVL_Visu.stVisu_DAB_SCAP_set.bONOFF", "bool",
           "N/A"},
          {"Reset Converter [Rising/Falling edge]", "GVL_Visu.stVisu_DAB_SCAP_set.bReset", "bool",
           "N/A"},
          {"Maksymalne napięcie obwodu pośredniczącego DC",
           "GVL_Visu.stVisu_DAB_SCAP_set.rUHVmax", "V", "N/A"},
          {"Maksymalne napięcie odbiornika", "GVL_Visu.stVisu_DAB_SCAP_set.rULVmax", "V", "N/A"},
          {"Minimalne napięcie obwodu pośredniczącego DC", "GVL_Visu.stVisu_DAB_SCAP_set.rUHVmin",
           "V", "N/A"},
          {"Minimalne napięcie odbiornika", "GVL_Visu.stVisu_DAB_SCAP_set.rULVmin", "V", "N/A"},
          {"Maksymalny prąd obwodu pośredniczącego DC", "GVL_Visu.stVisu_DAB_SCAP_set.rIHVmax",
           "A", "N/A"},
          {"Maksymalny prąd odbiornika", "GVL_Visu.stVisu_DAB_SCAP_set.rILVmax", "A", "N/A"},
          {"Set the power of the converter", "GVL_Visu.stVisu_DAB_SCAP_set.rPowerSet", "", "N/A"},
          {"Address IP device '10.0.10.x'", "GVL_Visu.stVisu_DAB_SCAP_set.IP_address", "string",
           "N/A"},
          {"Number ID device", "GVL_Visu.stVisu_DAB_SCAP_set.ID_number", "int", "N/A"}
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
          # Read
          {"Daily Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_LV_read.EPday", "kWh",
           "N/A"},
          {"Total Energy Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_LV_read.EPtotal", "kWh",
           "N/A"},
          {"Voltage RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_LV_read.Urms", "V", "N/A"},
          {"Current RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_LV_read.Irms", "A", "N/A"},
          {"Active Power RMS Measurement", "GVL_Visu.stVisu_MeterDC_DAB_EV_LV_read.Prms", "W",
           "N/A"},
          {"Meter status", "GVL_Visu.stVisu_MeterDC_DAB_EV_LV_read.Status", "", "N/A"},
          {"Connections [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_EV_LV_read.Connection", "",
           "N/A"},

          # Set
          {"Switch meter on/off [true/false]", "GVL_Visu.stVisu_MeterDC_DAB_EV_LV_set.bONOFF",
           "bool", "N/A"},
          {"Reset daily energy [true/false]",
           "GVL_Visu.stVisu_MeterDC_DAB_EV_LV_set.bResetDailyEnergy", "bool", "N/A"}
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
