# ============================================================
# EGO1 Flappy Bird VGA Constraints
# top module: top_vga
# ============================================================

# System Clock - 100 MHz
set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

# 4x4 Keypad - experimental J5 guess
# Current RTL mapping:
#   1 = start
#   5 = flap
#   D = reset
#
# This guess uses the clearly visible EGO1 silk-screen labels near J5:
#   rows: CA0(B4), CB0(A4), CC0(A3), CD0(B1)
#   cols: DK1(G2), DK2(C2), DK3(C1), DK4(H1)
# If the keypad has no response, J5 is probably mapped differently or
# row/column direction is swapped.

set_property PACKAGE_PIN B4 [get_ports {keypad_row[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {keypad_row[0]}]
set_property PULLUP true [get_ports {keypad_row[0]}]
set_property PACKAGE_PIN A4 [get_ports {keypad_row[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {keypad_row[1]}]
set_property PULLUP true [get_ports {keypad_row[1]}]
set_property PACKAGE_PIN A3 [get_ports {keypad_row[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {keypad_row[2]}]
set_property PULLUP true [get_ports {keypad_row[2]}]
set_property PACKAGE_PIN B1 [get_ports {keypad_row[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {keypad_row[3]}]
set_property PULLUP true [get_ports {keypad_row[3]}]

set_property PACKAGE_PIN G2 [get_ports {keypad_col[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {keypad_col[0]}]
set_property PACKAGE_PIN C2 [get_ports {keypad_col[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {keypad_col[1]}]
set_property PACKAGE_PIN C1 [get_ports {keypad_col[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {keypad_col[2]}]
set_property PACKAGE_PIN H1 [get_ports {keypad_col[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {keypad_col[3]}]

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
