# SITLINV XC7K325T Notes

Copyright 2023 Douglas P. Fields, Jr. symbolics@lisp.engineer

Provided under Solderpad Hardware License 2.1 - see [`LICENSE`](LICENSE)
and [`NOTICE`](NOTICE) files.

References:
* [Board purchase link](https://www.aliexpress.us/item/3256801088848039.html)
  * Shows 2023-02-23 V2.1 on my board
  * I have the FMC populated
  * I do NOT have the [Si5338](https://www.skyworksinc.com/-/media/Skyworks/SL/documents/public/data-sheets/Si5338.pdf) chip
    * (Maybe I should have gotten this)
  * I purchased the JTAG programmer with it
* [Blinky Example](https://github.com/fusesoc/blinky/commit/0f140e0f04188b53eaefd75418a4cad2d8546435) by Anderson Ignacio da Silva
  * He calls the board STVL7325 but my board has no such identifier on it

# Information Direct from Vendor

* "The red board has no 2.5V" (on the GPIO A-E)
  * 3.3V is available in the A-E GPIO, but not 2.5V anymore
* "Yes, but there are three different suffixes in vivado. When we use this, we choose the suffix xxxxxx0."
  * Original: "是的，但是vivado里面有三个不同的后缀。我们使用的时候选择后缀是xxxxxxxx0的这个。"
  * Not sure which question this was a response to:
    * Datasheet for Spansion FL256SAIFGO?
    * RTL8211 TXDLY & RXDLY are pulled up by 10k resistor, correct?


# Open Questions

* What are the pins for the two HDMI ports? (XLS file has only one)
* What are the pins for the DDR3 SODIMM?
* What are the pins for the RTL8211? (XLS file has 88E1111)
* How do I get the JTAG programmer to be fast, 
  and the Hardware Manager in Vivado to be fast?
  * Do I need to set some jumper?
* What can connect to the B2B connector?


# TODO

* Make a universal template
  * Top level SystemVerilog with every pin
  * Top level XDC file with every pin


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
   * Connect programmer to computer - use a USB-A port
     * I was unable to get a USB-C port to work
     * I use the 6-pin JTAG cable from the programmer to the board
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
   * Takes a *very long time* but reports information eventually
   * Avoid doing this, it pretty much hangs Vivado
   * Some information shown:
     * BSCAN_SWITCH_USER_MASK: 0001
     * CLASS: hw_device
     * DID: jsn-X-MLCC-01-DebugChannelA-43651093-0
     * IDCODE_HEX: 43651093
     * USER_CHAIN_COUNT: 4
     * XSDB_USER_BSCAN: 1,3
     * MASK_HEX: 0FFFFFFF
     * IS_SYSMON_SUPPORTED: CHECK
     * IR_LENGTH: 6
     * PART: xc7k325t
     * REGISTER -> BOOT_STATUS: 1 (STATUS_VALID)
     * REGISTER.CONFIG_STATUS	01010000000100000111100111111100
       * REGISTER.CONFIG_STATUS.BIT00_CRC_ERROR	0
       * REGISTER.CONFIG_STATUS.BIT01_DECRYPTOR_ENABLE	0
       * REGISTER.CONFIG_STATUS.BIT02_PLL_LOCK_STATUS	1
       * REGISTER.CONFIG_STATUS.BIT03_DCI_MATCH_STATUS	1
       * REGISTER.CONFIG_STATUS.BIT04_END_OF_STARTUP_(EOS)_STATUS	1
       * REGISTER.CONFIG_STATUS.BIT05_GTS_CFG_B_STATUS	1
       * REGISTER.CONFIG_STATUS.BIT06_GWE_STATUS	1
       * REGISTER.CONFIG_STATUS.BIT07_GHIGH_STATUS	1
       * REGISTER.CONFIG_STATUS.BIT08_MODE_PIN_M[0]	1
       * REGISTER.CONFIG_STATUS.BIT09_MODE_PIN_M[1]	0
       * REGISTER.CONFIG_STATUS.BIT10_MODE_PIN_M[2]	0
       * REGISTER.CONFIG_STATUS.BIT11_INIT_B_INTERNAL_SIGNAL_STATUS	1
       * REGISTER.CONFIG_STATUS.BIT12_INIT_B_PIN	1
       * REGISTER.CONFIG_STATUS.BIT13_DONE_INTERNAL_SIGNAL_STATUS	1
       * REGISTER.CONFIG_STATUS.BIT14_DONE_PIN	1
       * REGISTER.CONFIG_STATUS.BIT15_IDCODE_ERROR	0
       * REGISTER.CONFIG_STATUS.BIT16_SECURITY_ERROR	0
       * REGISTER.CONFIG_STATUS.BIT17_SYSTEM_MONITOR_OVER-TEMP_ALARM_STATUS	0
       * REGISTER.CONFIG_STATUS.BIT18_CFG_STARTUP_STATE_MACHINE_PHASE	100
       * REGISTER.CONFIG_STATUS.BIT21_RESERVED	0000
       * REGISTER.CONFIG_STATUS.BIT25_CFG_BUS_WIDTH_DETECTION	00
       * REGISTER.CONFIG_STATUS.BIT27_HMAC_ERROR	0
       * REGISTER.CONFIG_STATUS.BIT28_PUDC_B_PIN	1
       * REGISTER.CONFIG_STATUS.BIT29_BAD_PACKET_ERROR	0
       * REGISTER.CONFIG_STATUS.BIT30_CFGBVS_PIN	1
       * REGISTER.CONFIG_STATUS.BIT31_RESERVED	0
10. Misc notes




# Hardware Device Properties

Do _not_ do this, it seems to hang Vivado, so I did it once.

```
AUTH_JTAG.FILE	
BSCAN_SWITCH_USER_MASK	0001
CLASS	hw_device
DID	jsn-X-MLCC-01-DebugChannelA-43651093-0
FULL_PROBES.FILE	
IDCODE	01000011011001010001000010010011
IDCODE_HEX	43651093
INDEX	0
IR_LENGTH	6
IS_SYSMON_SUPPORTED	true
MASK	00001111111111111111111111111111
MASK_HEX	0FFFFFFF
NAME	xc7k325t_0
PART	xc7k325t
PARTIAL_PROBES.FILES	
PROBES.FILE	
PROGRAM.DPA_COUNT	0
PROGRAM.DPA_MODE	
PROGRAM.DPA_PROTECT	false
PROGRAM.FILE	D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/blinky_top.bit
PROGRAM.HW_BITSTREAM	D:/Doug/src/FPGA/sitlinv-1/sitlinv-1.runs/impl_1/blinky_top.bit
PROGRAM.HW_CFGMEM	
PROGRAM.HW_CFGMEM_BITFILE	
PROGRAM.HW_CFGMEM_TYPE	
PROGRAM.IS_AES_PROGRAMMED	false
PROGRAM.IS_RSA_PROGRAMMED	false
PROGRAM.IS_SUPPORTED	true
PROGRAM.OPTIONS	
PROGRAM.READBACK_FILE	
REGISTER.BOOT_STATUS	00000000000000000000000000000001
REGISTER.BOOT_STATUS.BIT00_0_STATUS_VALID	1
REGISTER.BOOT_STATUS.BIT01_0_FALLBACK	0
REGISTER.BOOT_STATUS.BIT02_0_INTERNAL_PROG	0
REGISTER.BOOT_STATUS.BIT03_0_WATCHDOG_TIMEOUT_ERROR	0
REGISTER.BOOT_STATUS.BIT04_0_ID_ERROR	0
REGISTER.BOOT_STATUS.BIT05_0_CRC_ERROR	0
REGISTER.BOOT_STATUS.BIT06_0_WRAP_ERROR	0
REGISTER.BOOT_STATUS.BIT07_0_SECURITY_ERROR	0
REGISTER.BOOT_STATUS.BIT08_1_STATUS_VALID	0
REGISTER.BOOT_STATUS.BIT09_1_FALLBACK	0
REGISTER.BOOT_STATUS.BIT10_1_INTERNAL_PROG	0
REGISTER.BOOT_STATUS.BIT11_1_WATCHDOG_TIMEOUT_ERROR	0
REGISTER.BOOT_STATUS.BIT12_1_ID_ERROR	0
REGISTER.BOOT_STATUS.BIT13_1_CRC_ERROR	0
REGISTER.BOOT_STATUS.BIT14_1_WRAP_ERROR	0
REGISTER.BOOT_STATUS.BIT15_1_SECURITY_ERROR	0
REGISTER.BOOT_STATUS.BIT16_RESERVED	0000000000000000
REGISTER.CONFIG_STATUS	01010000000100000111100111111100
REGISTER.CONFIG_STATUS.BIT00_CRC_ERROR	0
REGISTER.CONFIG_STATUS.BIT01_DECRYPTOR_ENABLE	0
REGISTER.CONFIG_STATUS.BIT02_PLL_LOCK_STATUS	1
REGISTER.CONFIG_STATUS.BIT03_DCI_MATCH_STATUS	1
REGISTER.CONFIG_STATUS.BIT04_END_OF_STARTUP_(EOS)_STATUS	1
REGISTER.CONFIG_STATUS.BIT05_GTS_CFG_B_STATUS	1
REGISTER.CONFIG_STATUS.BIT06_GWE_STATUS	1
REGISTER.CONFIG_STATUS.BIT07_GHIGH_STATUS	1
REGISTER.CONFIG_STATUS.BIT08_MODE_PIN_M[0]	1
REGISTER.CONFIG_STATUS.BIT09_MODE_PIN_M[1]	0
REGISTER.CONFIG_STATUS.BIT10_MODE_PIN_M[2]	0
REGISTER.CONFIG_STATUS.BIT11_INIT_B_INTERNAL_SIGNAL_STATUS	1
REGISTER.CONFIG_STATUS.BIT12_INIT_B_PIN	1
REGISTER.CONFIG_STATUS.BIT13_DONE_INTERNAL_SIGNAL_STATUS	1
REGISTER.CONFIG_STATUS.BIT14_DONE_PIN	1
REGISTER.CONFIG_STATUS.BIT15_IDCODE_ERROR	0
REGISTER.CONFIG_STATUS.BIT16_SECURITY_ERROR	0
REGISTER.CONFIG_STATUS.BIT17_SYSTEM_MONITOR_OVER-TEMP_ALARM_STATUS	0
REGISTER.CONFIG_STATUS.BIT18_CFG_STARTUP_STATE_MACHINE_PHASE	100
REGISTER.CONFIG_STATUS.BIT21_RESERVED	0000
REGISTER.CONFIG_STATUS.BIT25_CFG_BUS_WIDTH_DETECTION	00
REGISTER.CONFIG_STATUS.BIT27_HMAC_ERROR	0
REGISTER.CONFIG_STATUS.BIT28_PUDC_B_PIN	1
REGISTER.CONFIG_STATUS.BIT29_BAD_PACKET_ERROR	0
REGISTER.CONFIG_STATUS.BIT30_CFGBVS_PIN	1
REGISTER.CONFIG_STATUS.BIT31_RESERVED	0
REGISTER.COR0	02003fe5
REGISTER.COR0.BIT00_GWE_CYCLE	101
REGISTER.COR0.BIT03_GTS_CYCLE	100
REGISTER.COR0.BIT06_LOCK_CYCLE	111
REGISTER.COR0.BIT09_MATCH_CYCLE	111
REGISTER.COR0.BIT12_DONE_CYCLE	011
REGISTER.COR0.BIT15_SSCLKSRC	00
REGISTER.COR0.BIT17_OSCFSEL	000000
REGISTER.COR0.BIT23_SINGLE	0
REGISTER.COR0.BIT24_DRIVE_DONE	0
REGISTER.COR0.BIT25_DONE_PIPE	1
REGISTER.COR0.BIT26_RESERVED	0
REGISTER.COR0.BIT27_PWRDWN_STAT	0
REGISTER.COR0.BIT28_RESERVED	0000
REGISTER.COR1.BIT00_BPI_PAGE_SIZE	00
REGISTER.COR1.BIT02_BPI_1ST_READ_CYCLE	00
REGISTER.COR1.BIT04_RESERVED	0000
REGISTER.COR1.BIT08_RBCRC_EN	0
REGISTER.COR1.BIT09_RBCRC_NO_PIN	0
REGISTER.COR1.BIT10_RESERVED	00000
REGISTER.COR1.BIT15_RBCRC_ACTION	00
REGISTER.COR1.BIT17_PERSIST_DEASSERT_AT_DESYNC	0
REGISTER.COR1.BIT18_RESERVED	00000000000000
REGISTER.EFUSE.DNA_PORT	028140A4325885C
REGISTER.EFUSE.FUSE_CNTL	00C0
REGISTER.EFUSE.FUSE_DNA	3A11A4C250281457
REGISTER.EFUSE.FUSE_KEY	0000000000000000000000000000000000000000000000000000000000000000
REGISTER.EFUSE.FUSE_USER	00000000
REGISTER.IR	110101
REGISTER.IR.BIT0_ALWAYS_ONE	1
REGISTER.IR.BIT1_ALWAYS_ZERO	0
REGISTER.IR.BIT2_ISC_DONE	1
REGISTER.IR.BIT3_ISC_ENABLED	0
REGISTER.IR.BIT4_INIT_COMPLETE	1
REGISTER.IR.BIT5_DONE	1
REGISTER.TIMER	00000000
REGISTER.TIMER.BIT00_TIMER_VALUE	000000000000000000000000000000
REGISTER.TIMER.BIT30_TIMER_CFG_MON	0
REGISTER.TIMER.BIT31_TIMER_USR_MON	0
REGISTER.USERCODE	ffffffff
REGISTER.USR_ACCESS	00000000
REGISTER.WBSTAR	00000000
REGISTER.WBSTAR.BIT00_START_ADDR	00000000000000000000000000000
REGISTER.WBSTAR.BIT29_RS_TS_B	0
REGISTER.WBSTAR.BIT30_RS	00
UNKNOWN_DEVICE	false
USER_CHAIN_COUNT	4
VARIANT_NAME	
XSDB_USER_BSCAN	1,3
```

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