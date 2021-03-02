# Vivado project to experiment with PL-PS interfaces

## Structure

* **ip_repo:** repository of own made components
* **hardware:** Tcl files to recreate block designs in Vivado
* **firmware:** C files to use in SDK

## Instructions

* Create a project for the desired board
* Add ip_repo path to the project (Settings -> IP -> Repository -> +)
* Run in the *Tcl console* the command `source <PATH_TO_HARDWARE_DIRECTORY>/<PROJECT>.tcl`
* If needed [change the demo board](#change-the-demo-board)
* Create a wrapper for the design
* Generate Bitstream
* Export Hardware (include the Bitstream)
* Launch the SDK
* Create a new baremetal app
* Add the needed `<PATH_TO_FIRMWARE_DIRECTORY/FILE>.c`
* Also add `<PATH_TO_FIRMWARE_DIRECTORY>/shared.c` and `<PATH_TO_FIRMWARE_DIRECTORY>/shared.h`
* Program the FPGA, connect the UART and run the app
* Enjoy :-)

## Change the Demo Board

* Remove the Zynq block (inside PS_and_support herarchy)
* Add Zynq block again
* *Run Block Auotomation* with *Apply Board Preset* seleted
* Configure the Zynq:
    * Add AXI_HP0
    * Remove Peripheral I/O pins (except the UART used as Debug)
    * Add GPIO EMIO Pins (32 bits)
    * Config PL clock = 150 MHz
* Connect GPIO (input to Zynq)
* Connect FCLK_RESET0_N to ext_reset_in
* Connect DDR_0 and FIXED_IO_0
* *Run Connection Automatation*
* *Validate Design*

## Additional instructions

* Create the Vivado projects in a directory called *ignore* (included in *.gitignore* file)
* **Do not** add a Vivado's project directory under the **Control Version System!!! (GIT)**
* When a block design is changed, run *File -> Export -> Export Block Design* and overwite the content in **hardware** directory
* When a C file is changed, overwrite the content in the **firmware** directory

## ip_repo content

* AXI4_Masters_1.0:
    * A free running counter with two (Lite and Full) master interfaces.
    * Is controlled with an extra AXI Lite slave.
* AXI4_Slaves_1.0:
    * A free running counter with two (Lite and Full) slave interfaces.
    * It also has a gpio output (32 bits).
    * Is controlled by the AXI Lite Slave.
* AXI4_Stream_1.0:
    * A free running counter with one Stream master interface.
    * Is controlled with an extra AXI Lite slave.
* AXI3_BurstSniffer_1.0:
    * A sniffer of 4 AXI3 interfaces.
    * The *magic* to be interconnected with normal AXI3 buses, is the use of *monitor* interfaces (in IP packager).

## hardware content

* `<BOARD>_main.tcl`:
    * One AXI4_Slaves is connected to M_AXI_GP0 and GPIO_i.
    * Three AXI4_Masters are connected to S_AXI_ACP, S_AXI_GP0 and S_AXI_HP0.
* `<BOARD>_dmas.tcl`:
    * Three AXI4_Stream are connected to S_AXI_ACP, S_AXI_GP0 and S_AXI_HP0, trougth three AXI DMA.
* `<BOARD>_cache.tcl`:
    * One AXI4_Slaves is connected to M_AXI_GP0 and to one BRAM controller.
    * To test cache to enable burst.
* `<BOARD>_axi_perf.tcl`:
    * Project of the XAPP1219
    * **Note:** is to big for the Zynq in the Zybo board.

## firmware content

* `slaves.c`: is used with `<BOARD>_main.tcl`.
* `masters.c`: is used with `<BOARD>_main.tcl`.
* `dmas.c`: is used with `<BOARD>_dmas.tcl`.
* `cache.c`: is used with `<BOARD>_cache.tcl`. 
* `shared.c`: used by `slaves.c`, `masters.c` and `cache.c`.
* `shared.h`: header file of `shared.c`.
* `axi_perf.c`: C file of the XAPP1219, to be used with `<BOARD>_axi_perf.tcl`.
