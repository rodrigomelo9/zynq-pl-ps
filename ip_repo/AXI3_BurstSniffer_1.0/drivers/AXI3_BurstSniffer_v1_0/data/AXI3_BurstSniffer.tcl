

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "AXI3_BurstSniffer" "NUM_INSTANCES" "DEVICE_ID"  "C_S_AXIL_BASEADDR" "C_S_AXIL_HIGHADDR" "C_SLOT_0_BASEADDR" "C_SLOT_0_HIGHADDR" "C_SLOT_1_BASEADDR" "C_SLOT_1_HIGHADDR" "C_SLOT_2_BASEADDR" "C_SLOT_2_HIGHADDR" "C_SLOT_3_BASEADDR" "C_SLOT_3_HIGHADDR"
}
