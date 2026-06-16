read_verilog {C:/ego1_vga_color_build2/rtl/vga_sync.v}
read_verilog {C:/ego1_vga_color_build2/rtl/top_vga_color_test.v}
read_xdc {C:/ego1_vga_color_build2/constraints/ego1_vga_color_test.xdc}

synth_design -top top_vga_color_test -part xc7a35tcsg324-1
opt_design
place_design
route_design

report_utilization -file {C:/ego1_vga_color_build2/reports/utilization.rpt}
report_timing_summary -file {C:/ego1_vga_color_build2/reports/timing_summary.rpt}

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

write_bitstream -force {C:/ego1_vga_color_build2/bitstream/top_vga_color_test.bit}
exit
