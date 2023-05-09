# See: https://github.com/fusesoc/blinky/commit/0f140e0f04188b53eaefd75418a4cad2d8546435
# See example code provided by board vendor
#   ./CD2/sd_test/sd_test/constrs_1/new/sd.xdc

# Required settings lest Vivado complain
set_property CFGBVS VCCO [current_design]
# This one seems to have examples at 3.3 and 2.5 on the two reference CDs
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Clock signal
set_property -dict { PACKAGE_PIN AC11 IOSTANDARD LVDS } [get_ports { CLK_200_N }];
set_property -dict { PACKAGE_PIN AB11 IOSTANDARD LVDS } [get_ports { CLK_200_P }];
# Generate a single-ended clock from the above differential clock
create_clock -add -name sys_clk_pin -period 5 [get_nets clk_200];

# LEDs
set_property -dict { PACKAGE_PIN AA2  IOSTANDARD LVCMOS15 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN AD5  IOSTANDARD LVCMOS15 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN W10  IOSTANDARD LVCMOS15 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN Y10  IOSTANDARD LVCMOS15 } [get_ports { LED[3] }];
set_property -dict { PACKAGE_PIN AE10 IOSTANDARD LVCMOS15 } [get_ports { LED[4] }];
set_property -dict { PACKAGE_PIN W11  IOSTANDARD LVCMOS15 } [get_ports { LED[5] }];
set_property -dict { PACKAGE_PIN V11  IOSTANDARD LVCMOS15 } [get_ports { LED[6] }];
set_property -dict { PACKAGE_PIN Y12  IOSTANDARD LVCMOS15 } [get_ports { LED[7] }];