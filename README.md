# Vivado for the SITLINV

1. Choose this part: xc7k325tffg676-2
2. Add source file, blinky_top - SystemVerilog
   * Don't specify inputs/outputs, we will do that later
   * This will show up in the Project Manager under Design Sources
3. Review [this top level](https://github.com/fusesoc/blinky/commit/0f140e0f04188b53eaefd75418a4cad2d8546435)
   * Add LED and positive/negative differential clocks
4. Add XDC: Add Sources -> Constraints -> Create File
   * See the constraints from above
   * Make sure the port names are from the top level
   * Add these lines:
     * `set_property CFGBVS VCCO [current_design]`
     * `set_property CONFIG_VOLTAGE 3.3 [current_design]`

5. Turn our differential clock into a single-ended clock with an `IBUFDS`
6. Build a blinker of all the LEDs with logic using the single-ended clock
7. Connect the JTAG programmer provided by vendor with JTAG cable connected
   * Power the FPGA board on
   * Connect to computer - use a USB-A port; I was unable to get a USB-C port
     to work
   * Go to Hardware Manager and hit Auto Connect
     * It takes a long time for it to find the board! 
     * 1:38 min:sec to detect the hw_server
     * 0:56 to open the hw target
     * 0:47 to refresh the target
   * Hardware shows: xilinx_tcf/Xilinx/DebugChannelA -> xc7k325t_0 -> XADC
8. Hardware Manager -> Program Device
   * It takes a very long time to program the board (says 38 seconds)
     * It stays at 1% for a long time, then quickly advances
   * And it should start blinking all 8 LEDs
     * Including the two LEDs on each SFP
9. Harrdware Manager -> Hardware Device Properties on xc7k325t_0 -> Properties
   * Takes a very long time but reports information
   * Vivado hung before this ended. Disconnecting USB did not help.
10. Misc notes




# Log from TCL Console

```
start_gui
create_project sitlinv-1 D:/Doug/src/FPGA/sitlinv-1 -part xc7k325tffg676-2
INFO: [IP_Flow 19-234] Refreshing IP repositories
INFO: [IP_Flow 19-1704] No user IP repositories specified
INFO: [IP_Flow 19-2313] Loaded Vivado IP repository 'C:/bin/fpga/Xilinx/Vivado/2021.2/data/ip'.
file mkdir D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/sources_1/new
close [ open D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/sources_1/new/blinky_top.sv w ]
add_files D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/sources_1/new/blinky_top.sv
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 6
WARNING: [Vivado 12-7122] Auto Incremental Compile:: No reference checkpoint was found in run synth_1. Auto-incremental flow will not be run, the standard flow will be run instead.
[Mon May  8 18:54:35 2023] Launched synth_1...
Run output will be captured here: D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/synth_1/runme.log
file mkdir D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/constrs_1
file mkdir D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/constrs_1/new
close [ open D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/constrs_1/new/blinky.xdc w ]
add_files -fileset constrs_1 D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/constrs_1/new/blinky.xdc
reset_run synth_1
INFO: [Project 1-1160] Copying file D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/synth_1/blinky_top.dcp to D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/utils_1/imports/synth_1 and adding it to utils fileset
launch_runs synth_1 -jobs 6
[Mon May  8 19:01:24 2023] Launched synth_1...
Run output will be captured here: D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/synth_1/runme.log
launch_runs impl_1 -jobs 6
[Mon May  8 19:02:06 2023] Launched impl_1...
Run output will be captured here: D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/runme.log
launch_runs impl_1 -to_step write_bitstream -jobs 6
[Mon May  8 19:03:38 2023] Launched impl_1...
Run output will be captured here: D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/runme.log
open_hw_manager
connect_hw_server -allow_non_jtag
INFO: [Labtools 27-2285] Connecting to hw_server url TCP:localhost:3121
INFO: [Labtools 27-2222] Launching hw_server...
INFO: [Labtools 27-2221] Launch Output:

****** Xilinx hw_server v2021.2.1
  **** Build date : Dec 19 2021 at 11:24:48
    ** Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.


INFO: [Labtools 27-3415] Connecting to cs_server url TCP:localhost:3042
INFO: [Labtools 27-3417] Launching cs_server...
INFO: [Labtools 27-2221] Launch Output:


******** Xilinx cs_server v2021.2.0
  ****** Build date   : Sep 27 2021-17:44:20
    **** Build number : 2021.2.1632779060
      ** Copyright 2017-2023 Xilinx, Inc. All Rights Reserved.



connect_hw_server: Time (s): cpu = 00:00:02 ; elapsed = 00:01:46 . Memory (MB): peak = 1233.684 ; gain = 0.000
disconnect_hw_server localhost:3121
connect_hw_server -allow_non_jtag
INFO: [Labtools 27-2285] Connecting to hw_server url TCP:localhost:3121
INFO: [Common 17-41] Interrupt caught. Command should exit soon.
INFO: [Labtools 27-2058] connect_hw_server command cancelled.
connect_hw_server: Time (s): cpu = 00:00:00 ; elapsed = 00:00:21 . Memory (MB): peak = 1233.684 ; gain = 0.000
INFO: [Common 17-344] 'connect_hw_server' was cancelled
connect_hw_server -allow_non_jtag
INFO: [Labtools 27-2285] Connecting to hw_server url TCP:localhost:3121
INFO: [Labtools 27-3415] Connecting to cs_server url TCP:localhost:3042
INFO: [Labtools 27-3417] Launching cs_server...
INFO: [Labtools 27-2221] Launch Output:


******** Xilinx cs_server v2021.2.0
  ****** Build date   : Sep 27 2021-17:44:20
    **** Build number : 2021.2.1632779060
      ** Copyright 2017-2023 Xilinx, Inc. All Rights Reserved.



connect_hw_server: Time (s): cpu = 00:00:02 ; elapsed = 00:01:38 . Memory (MB): peak = 1233.684 ; gain = 0.000
open_hw_target
INFO: [Labtoolstcl 44-466] Opening hw_target localhost:3121/xilinx_tcf/Xilinx/DebugChannelA
open_hw_target: Time (s): cpu = 00:00:05 ; elapsed = 00:00:56 . Memory (MB): peak = 2808.836 ; gain = 1575.152
set_property PROGRAM.FILE {D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/blinky_top.bit} [get_hw_devices xc7k325t_0]
current_hw_device [get_hw_devices xc7k325t_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7k325t_0] 0]
INFO: [Labtools 27-1434] Device xc7k325t (JTAG device index = 0) is programmed with a design that has no supported debug core(s) in it.
refresh_hw_device: Time (s): cpu = 00:00:00 ; elapsed = 00:00:47 . Memory (MB): peak = 2829.688 ; gain = 20.633
set_property PROBES.FILE {} [get_hw_devices xc7k325t_0]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7k325t_0]
set_property PROGRAM.FILE {D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/blinky_top.bit} [get_hw_devices xc7k325t_0]
program_hw_devices [get_hw_devices xc7k325t_0]
INFO: [Labtools 27-3164] End of startup status: HIGH
program_hw_devices: Time (s): cpu = 00:00:08 ; elapsed = 00:00:38 . Memory (MB): peak = 2864.520 ; gain = 3.336
refresh_hw_device [lindex [get_hw_devices xc7k325t_0] 0]
INFO: [Labtools 27-1434] Device xc7k325t (JTAG device index = 0) is programmed with a design that has no supported debug core(s) in it.
ERROR: [Labtoolstcl 44-513] HW Target shutdown. Closing target: localhost:3121/xilinx_tcf/Xilinx/DebugChannelA
reset_run synth_1
INFO: [Project 1-1161] Replacing file D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/utils_1/imports/synth_1/blinky_top.dcp with file D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/synth_1/blinky_top.dcp
launch_runs impl_1 -to_step write_bitstream -jobs 6
[Mon May  8 19:32:22 2023] Launched synth_1...
Run output will be captured here: D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/synth_1/runme.log
[Mon May  8 19:32:22 2023] Launched impl_1...
Run output will be captured here: D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/runme.log
set_property PROBES.FILE {} [get_hw_devices xc7k325t_0]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7k325t_0]
set_property PROGRAM.FILE {D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/blinky_top.bit} [get_hw_devices xc7k325t_0]
program_hw_devices [get_hw_devices xc7k325t_0]
INFO: [Labtools 27-3164] End of startup status: HIGH
program_hw_devices: Time (s): cpu = 00:00:07 ; elapsed = 00:00:39 . Memory (MB): peak = 2939.617 ; gain = 0.426
refresh_hw_device [lindex [get_hw_devices xc7k325t_0] 0]
INFO: [Labtools 27-1434] Device xc7k325t (JTAG device index = 0) is programmed with a design that has no supported debug core(s) in it.
reset_run synth_1
INFO: [Project 1-1161] Replacing file D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.srcs/utils_1/imports/synth_1/blinky_top.dcp with file D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/synth_1/blinky_top.dcp
launch_runs impl_1 -to_step write_bitstream -jobs 6
[Mon May  8 19:57:15 2023] Launched synth_1...
Run output will be captured here: D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/synth_1/runme.log
[Mon May  8 19:57:15 2023] Launched impl_1...
Run output will be captured here: D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/runme.log
set_property PROBES.FILE {} [get_hw_devices xc7k325t_0]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7k325t_0]
set_property PROGRAM.FILE {D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/blinky_top.bit} [get_hw_devices xc7k325t_0]
program_hw_devices [get_hw_devices xc7k325t_0]
INFO: [Labtools 27-3164] End of startup status: HIGH
program_hw_devices: Time (s): cpu = 00:00:07 ; elapsed = 00:00:37 . Memory (MB): peak = 2942.645 ; gain = 3.027
refresh_hw_device [lindex [get_hw_devices xc7k325t_0] 0]
INFO: [Labtools 27-1434] Device xc7k325t (JTAG device index = 0) is programmed with a design that has no supported debug core(s) in it.
````