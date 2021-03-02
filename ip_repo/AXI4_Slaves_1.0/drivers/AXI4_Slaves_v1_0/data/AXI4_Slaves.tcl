

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "AXI4_Slaves" "NUM_INSTANCES" "DEVICE_ID"  "C_S_AXIL_BASEADDR" "C_S_AXIL_HIGHADDR" "C_S_AXIF_BASEADDR" "C_S_AXIF_HIGHADDR"
}
