# See: https://github.com/fusesoc/blinky/commit/0f140e0f04188b53eaefd75418a4cad2d8546435
# See example code provided by board vendor
#   ./CD2/sd_test/sd_test/constrs_1/new/sd.xdc

# Required settings lest Vivado complain
set_property CFGBVS VCCO [current_design]
# This one seems to have examples at 3.3 and 2.5 on the two reference CDs
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Clock signals
set_property -dict { PACKAGE_PIN AC11 IOSTANDARD LVDS } [get_ports { CLK_200_N }]; # Some say DIFF_SSTL15
set_property -dict { PACKAGE_PIN AB11 IOSTANDARD LVDS } [get_ports { CLK_200_P }];
create_clock -period 5.000 [get_ports CLK_200_P]
# An example shows this instead of the above:
## set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]

# Generate a single-ended clock from the above differential clock
create_clock -add -name sys_clk_pin -period 5 [get_nets clk_200];

set_property PACKAGE_PIN F17 [get_ports CLK_100]
set_property IOSTANDARD LVCMOS25 [get_ports CLK_100]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports CLK_100]
set_input_jitter [get_clocks -of_objects [get_ports CLK_100]] 0.1

# TODO: Set up 150, 156.25M clocks

# XLS file shows these clocks:
# F17 "Y2" - 100M - 2.5/3.3V depending on J4
# AB11/AC11 - "Y1" - 200M p/n - DIFF_SSTL15	
# D6/D5 - "Y5" - 156.25M LVDS p/n
# F6/F5 - "Y4" - 150M LVDS p/n



# Other clocks found in the demo code: 
#   grep --color=auto --include='*.xdc' -rhy "package_pin.*clk" CD*/*
# D5, D6 - PCIe n/p
# H5, H6 - PCIe n/p too?
# B26 - EMC (?)
# D15 and R21 - HDMI1 CLK
# J14 - HDMI2 CLK
# F17 - ??? 100M? LVCMOS33
# AB11/AC11 - 200M clock p/n
# C8 - 100M clock LVCMOS15
# K6 - Si5338 CLK2 (no Si5338 on my board)


# LEDs
set_property -dict { PACKAGE_PIN AA2  IOSTANDARD LVCMOS15 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN AD5  IOSTANDARD LVCMOS15 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN W10  IOSTANDARD LVCMOS15 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN Y10  IOSTANDARD LVCMOS15 } [get_ports { LED[3] }];
set_property -dict { PACKAGE_PIN AE10 IOSTANDARD LVCMOS15 } [get_ports { LED[4] }];
set_property -dict { PACKAGE_PIN W11  IOSTANDARD LVCMOS15 } [get_ports { LED[5] }];
set_property -dict { PACKAGE_PIN V11  IOSTANDARD LVCMOS15 } [get_ports { LED[6] }];
set_property -dict { PACKAGE_PIN Y12  IOSTANDARD LVCMOS15 } [get_ports { LED[7] }];

# Keys
# They are both different voltages per XLS file
# KEY[1] is labeled K3 on the board
set_property PACKAGE_PIN C24 [get_ports { KEY[1] }]
set_property IOSTANDARD LVCMOS33 [get_ports { KEY[1] }]
# KEY[0] is labeled K2 on the board
set_property PACKAGE_PIN AC16 [get_ports { KEY[0] }]
set_property IOSTANDARD LVCMOS15 [get_ports { KEY[0] }]
