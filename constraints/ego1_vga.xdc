# ============================================================
# EGO1 Flappy Bird VGA Constraints
# top module: top_vga
# ============================================================

# System Clock - 100 MHz
set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

# 4x4 Keypad
# Current RTL mapping:
#   1 = start
#   5 = flap
#   D = reset
#
# TODO: Fill these PACKAGE_PIN values based on the exact EGO1 header
# used by the external 4x4 keypad.
#
# set_property PACKAGE_PIN <PIN> [get_ports {keypad_row[0]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_row[0]}]
# set_property PULLUP true [get_ports {keypad_row[0]}]
# set_property PACKAGE_PIN <PIN> [get_ports {keypad_row[1]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_row[1]}]
# set_property PULLUP true [get_ports {keypad_row[1]}]
# set_property PACKAGE_PIN <PIN> [get_ports {keypad_row[2]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_row[2]}]
# set_property PULLUP true [get_ports {keypad_row[2]}]
# set_property PACKAGE_PIN <PIN> [get_ports {keypad_row[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_row[3]}]
# set_property PULLUP true [get_ports {keypad_row[3]}]
#
# set_property PACKAGE_PIN <PIN> [get_ports {keypad_col[0]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_col[0]}]
# set_property PACKAGE_PIN <PIN> [get_ports {keypad_col[1]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_col[1]}]
# set_property PACKAGE_PIN <PIN> [get_ports {keypad_col[2]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_col[2]}]
# set_property PACKAGE_PIN <PIN> [get_ports {keypad_col[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_col[3]}]

# VGA Red[3:0]
set_property PACKAGE_PIN F5 [get_ports {vga_r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[0]}]
set_property PACKAGE_PIN C6 [get_ports {vga_r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN C5 [get_ports {vga_r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN B7 [get_ports {vga_r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[3]}]

# VGA Green[3:0]
set_property PACKAGE_PIN B6 [get_ports {vga_g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[0]}]
set_property PACKAGE_PIN A6 [get_ports {vga_g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN A5 [get_ports {vga_g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN D8 [get_ports {vga_g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[3]}]

# VGA Blue[3:0]
set_property PACKAGE_PIN C7 [get_ports {vga_b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[0]}]
set_property PACKAGE_PIN E6 [get_ports {vga_b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN E5 [get_ports {vga_b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN E7 [get_ports {vga_b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[3]}]

# VGA Sync
set_property PACKAGE_PIN D7 [get_ports vga_hsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hsync]
set_property PACKAGE_PIN C4 [get_ports vga_vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vsync]

# LED Debug
set_property PACKAGE_PIN K3 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN M1 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN L1 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN K6 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
