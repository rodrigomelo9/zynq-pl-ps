

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "AXI4_Stream" "NUM_INSTANCES" "DEVICE_ID"  "C_AXIL_BASEADDR" "C_AXIL_HIGHADDR"
}
