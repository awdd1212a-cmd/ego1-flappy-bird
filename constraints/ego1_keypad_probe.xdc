# ============================================================
# EGO1 J5 keypad probe constraints
# top ports:
# clk, rst, j5[31:0], led[15:0]
# ============================================================

# Clock: 100 MHz
set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

# Reset button: S4
set_property PACKAGE_PIN U4 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# LEDs D1_0..D1_7
set_property PACKAGE_PIN K3 [get_ports {led[0]}]
set_property PACKAGE_PIN M1 [get_ports {led[1]}]
set_property PACKAGE_PIN L1 [get_ports {led[2]}]
set_property PACKAGE_PIN K6 [get_ports {led[3]}]
set_property PACKAGE_PIN J5 [get_ports {led[4]}]
set_property PACKAGE_PIN H5 [get_ports {led[5]}]
set_property PACKAGE_PIN H6 [get_ports {led[6]}]
set_property PACKAGE_PIN K1 [get_ports {led[7]}]

# LEDs D2_0..D2_7
set_property PACKAGE_PIN K2 [get_ports {led[8]}]
set_property PACKAGE_PIN J2 [get_ports {led[9]}]
set_property PACKAGE_PIN J3 [get_ports {led[10]}]
set_property PACKAGE_PIN H4 [get_ports {led[11]}]
set_property PACKAGE_PIN J4 [get_ports {led[12]}]
set_property PACKAGE_PIN G3 [get_ports {led[13]}]
set_property PACKAGE_PIN G4 [get_ports {led[14]}]
set_property PACKAGE_PIN F6 [get_ports {led[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# J5 2x18 expansion header, usable IO 1..32.
set_property PACKAGE_PIN B16 [get_ports {j5[0]}]
set_property PACKAGE_PIN B17 [get_ports {j5[1]}]
set_property PACKAGE_PIN A15 [get_ports {j5[2]}]
set_property PACKAGE_PIN A16 [get_ports {j5[3]}]
set_property PACKAGE_PIN A13 [get_ports {j5[4]}]
set_property PACKAGE_PIN A14 [get_ports {j5[5]}]
set_property PACKAGE_PIN B18 [get_ports {j5[6]}]
set_property PACKAGE_PIN A18 [get_ports {j5[7]}]
set_property PACKAGE_PIN F13 [get_ports {j5[8]}]
set_property PACKAGE_PIN F14 [get_ports {j5[9]}]
set_property PACKAGE_PIN B13 [get_ports {j5[10]}]
set_property PACKAGE_PIN B14 [get_ports {j5[11]}]
set_property PACKAGE_PIN D14 [get_ports {j5[12]}]
set_property PACKAGE_PIN C14 [get_ports {j5[13]}]
set_property PACKAGE_PIN B11 [get_ports {j5[14]}]
set_property PACKAGE_PIN A11 [get_ports {j5[15]}]
set_property PACKAGE_PIN E15 [get_ports {j5[16]}]
set_property PACKAGE_PIN E16 [get_ports {j5[17]}]
set_property PACKAGE_PIN D15 [get_ports {j5[18]}]
set_property PACKAGE_PIN C15 [get_ports {j5[19]}]
set_property PACKAGE_PIN H16 [get_ports {j5[20]}]
set_property PACKAGE_PIN G16 [get_ports {j5[21]}]
set_property PACKAGE_PIN F15 [get_ports {j5[22]}]
set_property PACKAGE_PIN F16 [get_ports {j5[23]}]
set_property PACKAGE_PIN H14 [get_ports {j5[24]}]
set_property PACKAGE_PIN G14 [get_ports {j5[25]}]
set_property PACKAGE_PIN E17 [get_ports {j5[26]}]
set_property PACKAGE_PIN D17 [get_ports {j5[27]}]
set_property PACKAGE_PIN K13 [get_ports {j5[28]}]
set_property PACKAGE_PIN J13 [get_ports {j5[29]}]
set_property PACKAGE_PIN H17 [get_ports {j5[30]}]
set_property PACKAGE_PIN G17 [get_ports {j5[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {j5[*]}]
set_property PULLUP true [get_ports {j5[*]}]
