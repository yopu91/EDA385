##############################################################################
## Filename:          C:\temp/drivers/vga_ip_v2_00_a/data/vga_ip_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Fri Sep 25 09:27:18 2015 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "vga_ip" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
