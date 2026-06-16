read_verilog {C:/ego1_top_vga_build/rtl/button_ctrl.v}
read_verilog {C:/ego1_top_vga_build/rtl/game_fsm.v}
read_verilog {C:/ego1_top_vga_build/rtl/bird_ctrl.v}
read_verilog {C:/ego1_top_vga_build/rtl/pipe_ctrl.v}
read_verilog {C:/ego1_top_vga_build/rtl/collision.v}
read_verilog {C:/ego1_top_vga_build/rtl/score_ctrl.v}
read_verilog {C:/ego1_top_vga_build/rtl/vga_sync.v}
read_verilog {C:/ego1_top_vga_build/rtl/vga_renderer.v}
read_verilog {C:/ego1_top_vga_build/rtl/top_vga.v}
read_xdc {C:/ego1_top_vga_build/constraints/ego1_vga.xdc}

synth_design -top top_vga -part xc7a35tcsg324-1
opt_design
place_design
route_design

report_utilization -file {C:/ego1_top_vga_build/reports/utilization.rpt}
report_timing_summary -file {C:/ego1_top_vga_build/reports/timing_summary.rpt}

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

write_bitstream -force {C:/ego1_top_vga_build/bitstream/top_vga.bit}
exit
