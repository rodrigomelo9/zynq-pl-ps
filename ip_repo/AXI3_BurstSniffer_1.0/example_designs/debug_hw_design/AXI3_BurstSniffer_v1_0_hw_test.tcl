# Runtime Tcl commands to interact with - AXI3_BurstSniffer_v1_0

# Sourcing design address info tcl
set bd_path [get_property DIRECTORY [current_project]]/[current_project].srcs/[current_fileset]/bd
source ${bd_path}/AXI3_BurstSniffer_v1_0_include.tcl

# jtag axi master interface hardware name, change as per your design.
set jtag_axi_master hw_axi_1
set ec 0

# hw test script
# Delete all previous axis transactions
if { [llength [get_hw_axi_txns -quiet]] } {
	delete_hw_axi_txn [get_hw_axi_txns -quiet]
}


# Test all lite slaves.
set wdata_1 abcd1234

# Test: S_AXIL
# Create a write transaction at s_axil_addr address
create_hw_axi_txn w_s_axil_addr [get_hw_axis $jtag_axi_master] -type write -address $s_axil_addr -data $wdata_1
# Create a read transaction at s_axil_addr address
create_hw_axi_txn r_s_axil_addr [get_hw_axis $jtag_axi_master] -type read -address $s_axil_addr
# Initiate transactions
run_hw_axi r_s_axil_addr
run_hw_axi w_s_axil_addr
run_hw_axi r_s_axil_addr
set rdata_tmp [get_property DATA [get_hw_axi_txn r_s_axil_addr]]
# Compare read data
if { $rdata_tmp == $wdata_1 } {
	puts "Data comparison test pass for - S_AXIL"
} else {
	puts "Data comparison test fail for - S_AXIL, expected-$wdata_1 actual-$rdata_tmp"
	inc ec
}


# Test all full slaves.
set wdata_2 04040404030303030202020201010101

# Test: SLOT_0
# Create a burst write transaction at slot_0_addr address
create_hw_axi_txn w_slot_0_addr [get_hw_axis $jtag_axi_master] -type write -address $slot_0_addr -len 4 -data $wdata_2 -burst INCR
# Create a burst read transaction at slot_0_addr address
create_hw_axi_txn r_slot_0_addr [get_hw_axis $jtag_axi_master] -type read -address $slot_0_addr -len 4 -burst INCR
# Initiate transactions
run_hw_axi r_slot_0_addr
run_hw_axi w_slot_0_addr
run_hw_axi r_slot_0_addr
set rdata_tmp [get_property DATA [get_hw_axi_txn r_slot_0_addr]]
# Compare read data
if { $rdata_tmp == $wdata_2 } {
	puts "Data comparison test pass for - SLOT_0"
} else {
	puts "Data comparison test fail for - SLOT_0, expected-$wdata_2 actual-$rdata_tmp"
	inc ec
}

# Test: SLOT_1
# Create a burst write transaction at slot_1_addr address
create_hw_axi_txn w_slot_1_addr [get_hw_axis $jtag_axi_master] -type write -address $slot_1_addr -len 4 -data $wdata_2 -burst INCR
# Create a burst read transaction at slot_1_addr address
create_hw_axi_txn r_slot_1_addr [get_hw_axis $jtag_axi_master] -type read -address $slot_1_addr -len 4 -burst INCR
# Initiate transactions
run_hw_axi r_slot_1_addr
run_hw_axi w_slot_1_addr
run_hw_axi r_slot_1_addr
set rdata_tmp [get_property DATA [get_hw_axi_txn r_slot_1_addr]]
# Compare read data
if { $rdata_tmp == $wdata_2 } {
	puts "Data comparison test pass for - SLOT_1"
} else {
	puts "Data comparison test fail for - SLOT_1, expected-$wdata_2 actual-$rdata_tmp"
	inc ec
}

# Test: SLOT_2
# Create a burst write transaction at slot_2_addr address
create_hw_axi_txn w_slot_2_addr [get_hw_axis $jtag_axi_master] -type write -address $slot_2_addr -len 4 -data $wdata_2 -burst INCR
# Create a burst read transaction at slot_2_addr address
create_hw_axi_txn r_slot_2_addr [get_hw_axis $jtag_axi_master] -type read -address $slot_2_addr -len 4 -burst INCR
# Initiate transactions
run_hw_axi r_slot_2_addr
run_hw_axi w_slot_2_addr
run_hw_axi r_slot_2_addr
set rdata_tmp [get_property DATA [get_hw_axi_txn r_slot_2_addr]]
# Compare read data
if { $rdata_tmp == $wdata_2 } {
	puts "Data comparison test pass for - SLOT_2"
} else {
	puts "Data comparison test fail for - SLOT_2, expected-$wdata_2 actual-$rdata_tmp"
	inc ec
}

# Test: SLOT_3
# Create a burst write transaction at slot_3_addr address
create_hw_axi_txn w_slot_3_addr [get_hw_axis $jtag_axi_master] -type write -address $slot_3_addr -len 4 -data $wdata_2 -burst INCR
# Create a burst read transaction at slot_3_addr address
create_hw_axi_txn r_slot_3_addr [get_hw_axis $jtag_axi_master] -type read -address $slot_3_addr -len 4 -burst INCR
# Initiate transactions
run_hw_axi r_slot_3_addr
run_hw_axi w_slot_3_addr
run_hw_axi r_slot_3_addr
set rdata_tmp [get_property DATA [get_hw_axi_txn r_slot_3_addr]]
# Compare read data
if { $rdata_tmp == $wdata_2 } {
	puts "Data comparison test pass for - SLOT_3"
} else {
	puts "Data comparison test fail for - SLOT_3, expected-$wdata_2 actual-$rdata_tmp"
	inc ec
}

# Check error flag
if { $ec == 0 } {
	 puts "PTGEN_TEST: PASSED!" 
} else {
	 puts "PTGEN_TEST: FAILED!" 
}

