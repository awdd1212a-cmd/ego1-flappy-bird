read_verilog {C:/ego1_top_vga_build/rtl/button_ctrl.v}
read_verilog {C:/ego1_top_vga_build/rtl/keypad_ctrl.v}
read_verilog {C:/ego1_top_vga_build/rtl/game_fsm.v}
read_verilog {C:/ego1_top_vga_build/rtl/bird_ctrl.v}
read_verilog {C:/ego1_top_vga_build/rtl/pipe_ctrl.v}
read_verilog {C:/ego1_top_vga_build/rtl/collision.v}
read_verilog {C:/ego1_top_vga_build/rtl/score_ctrl.v}
read_verilog {C:/ego1_top_vga_build/rtl/vga_sync.v}
read_verilog {C:/ego1_top_vga_build/rtl/vga_renderer.v}
read_verilog {C:/ego1_top_vga_build/rtl/top_vga.v}

synth_design -top top_vga -part xc7a35tcsg324-1
report_utilization -file {C:/ego1_top_vga_build/reports/synth_only_utilization.rpt}
exit
