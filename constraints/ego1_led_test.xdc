# ============================================================
# EGO1 Flappy Bird LED Board Test Constraints
# top ports:
# clk, rst, btnC, btnU, led[3:0]
# ============================================================

# Clock
set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

# Reset button
set_property PACKAGE_PIN U4 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Start button
set_property PACKAGE_PIN R11 [get_ports btnC]
set_property IOSTANDARD LVCMOS33 [get_ports btnC]

# Flap button
set_property PACKAGE_PIN R15 [get_ports btnU]
set_property IOSTANDARD LVCMOS33 [get_ports btnU]

# LEDs
set_property PACKAGE_PIN K3 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN M1 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN L1 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN K6 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
