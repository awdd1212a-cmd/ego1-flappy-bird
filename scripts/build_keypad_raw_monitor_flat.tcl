read_verilog {D:/ego1_keypad_raw_monitor_build/rtl/top_keypad_raw_monitor.v}
read_xdc {D:/ego1_keypad_raw_monitor_build/constraints/ego1_keypad_probe.xdc}

synth_design -top top_keypad_raw_monitor -part xc7a35tcsg324-1
opt_design
place_design
route_design

report_utilization -file {D:/ego1_keypad_raw_monitor_build/reports/utilization.rpt}
report_timing_summary -file {D:/ego1_keypad_raw_monitor_build/reports/timing_summary.rpt}

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

write_bitstream -force {D:/ego1_keypad_raw_monitor_build/bitstream/top_keypad_raw_monitor.bit}
exit
