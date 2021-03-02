# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set C_SLOT_3_ID_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_3_ID_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of ID for for write address, write data, read address and read data} ${C_SLOT_3_ID_WIDTH}
  set C_SLOT_3_DATA_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_3_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_SLOT_3_DATA_WIDTH}
  set C_SLOT_3_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_3_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_SLOT_3_ADDR_WIDTH}
  set C_SLOT_2_ID_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_2_ID_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of ID for for write address, write data, read address and read data} ${C_SLOT_2_ID_WIDTH}
  set C_SLOT_2_DATA_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_2_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_SLOT_2_DATA_WIDTH}
  set C_SLOT_2_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_2_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_SLOT_2_ADDR_WIDTH}
  set C_S_AXIL_DATA_WIDTH [ipgui::add_param $IPINST -name "C_S_AXIL_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_S_AXIL_DATA_WIDTH}
  set C_S_AXIL_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_S_AXIL_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_S_AXIL_ADDR_WIDTH}
  set C_SLOT_0_ID_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_0_ID_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of ID for for write address, write data, read address and read data} ${C_SLOT_0_ID_WIDTH}
  set C_SLOT_0_DATA_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_0_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_SLOT_0_DATA_WIDTH}
  set C_SLOT_0_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_0_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_SLOT_0_ADDR_WIDTH}
  set C_SLOT_1_ID_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_1_ID_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of ID for for write address, write data, read address and read data} ${C_SLOT_1_ID_WIDTH}
  set C_SLOT_1_DATA_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_1_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_SLOT_1_DATA_WIDTH}
  set C_SLOT_1_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_SLOT_1_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_SLOT_1_ADDR_WIDTH}


}

proc update_PARAM_VALUE.C_SLOT_3_ID_WIDTH { PARAM_VALUE.C_SLOT_3_ID_WIDTH } {
	# Procedure called to update C_SLOT_3_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_3_ID_WIDTH { PARAM_VALUE.C_SLOT_3_ID_WIDTH } {
	# Procedure called to validate C_SLOT_3_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_3_DATA_WIDTH { PARAM_VALUE.C_SLOT_3_DATA_WIDTH } {
	# Procedure called to update C_SLOT_3_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_3_DATA_WIDTH { PARAM_VALUE.C_SLOT_3_DATA_WIDTH } {
	# Procedure called to validate C_SLOT_3_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_3_ADDR_WIDTH { PARAM_VALUE.C_SLOT_3_ADDR_WIDTH } {
	# Procedure called to update C_SLOT_3_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_3_ADDR_WIDTH { PARAM_VALUE.C_SLOT_3_ADDR_WIDTH } {
	# Procedure called to validate C_SLOT_3_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_3_BASEADDR { PARAM_VALUE.C_SLOT_3_BASEADDR } {
	# Procedure called to update C_SLOT_3_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_3_BASEADDR { PARAM_VALUE.C_SLOT_3_BASEADDR } {
	# Procedure called to validate C_SLOT_3_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_SLOT_3_HIGHADDR { PARAM_VALUE.C_SLOT_3_HIGHADDR } {
	# Procedure called to update C_SLOT_3_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_3_HIGHADDR { PARAM_VALUE.C_SLOT_3_HIGHADDR } {
	# Procedure called to validate C_SLOT_3_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_SLOT_2_ID_WIDTH { PARAM_VALUE.C_SLOT_2_ID_WIDTH } {
	# Procedure called to update C_SLOT_2_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_2_ID_WIDTH { PARAM_VALUE.C_SLOT_2_ID_WIDTH } {
	# Procedure called to validate C_SLOT_2_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_2_DATA_WIDTH { PARAM_VALUE.C_SLOT_2_DATA_WIDTH } {
	# Procedure called to update C_SLOT_2_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_2_DATA_WIDTH { PARAM_VALUE.C_SLOT_2_DATA_WIDTH } {
	# Procedure called to validate C_SLOT_2_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_2_ADDR_WIDTH { PARAM_VALUE.C_SLOT_2_ADDR_WIDTH } {
	# Procedure called to update C_SLOT_2_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_2_ADDR_WIDTH { PARAM_VALUE.C_SLOT_2_ADDR_WIDTH } {
	# Procedure called to validate C_SLOT_2_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_2_BASEADDR { PARAM_VALUE.C_SLOT_2_BASEADDR } {
	# Procedure called to update C_SLOT_2_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_2_BASEADDR { PARAM_VALUE.C_SLOT_2_BASEADDR } {
	# Procedure called to validate C_SLOT_2_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_SLOT_2_HIGHADDR { PARAM_VALUE.C_SLOT_2_HIGHADDR } {
	# Procedure called to update C_SLOT_2_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_2_HIGHADDR { PARAM_VALUE.C_SLOT_2_HIGHADDR } {
	# Procedure called to validate C_SLOT_2_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXIL_DATA_WIDTH { PARAM_VALUE.C_S_AXIL_DATA_WIDTH } {
	# Procedure called to update C_S_AXIL_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIL_DATA_WIDTH { PARAM_VALUE.C_S_AXIL_DATA_WIDTH } {
	# Procedure called to validate C_S_AXIL_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIL_ADDR_WIDTH { PARAM_VALUE.C_S_AXIL_ADDR_WIDTH } {
	# Procedure called to update C_S_AXIL_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIL_ADDR_WIDTH { PARAM_VALUE.C_S_AXIL_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXIL_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIL_BASEADDR { PARAM_VALUE.C_S_AXIL_BASEADDR } {
	# Procedure called to update C_S_AXIL_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIL_BASEADDR { PARAM_VALUE.C_S_AXIL_BASEADDR } {
	# Procedure called to validate C_S_AXIL_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXIL_HIGHADDR { PARAM_VALUE.C_S_AXIL_HIGHADDR } {
	# Procedure called to update C_S_AXIL_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIL_HIGHADDR { PARAM_VALUE.C_S_AXIL_HIGHADDR } {
	# Procedure called to validate C_S_AXIL_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_SLOT_0_ID_WIDTH { PARAM_VALUE.C_SLOT_0_ID_WIDTH } {
	# Procedure called to update C_SLOT_0_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_0_ID_WIDTH { PARAM_VALUE.C_SLOT_0_ID_WIDTH } {
	# Procedure called to validate C_SLOT_0_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_0_DATA_WIDTH { PARAM_VALUE.C_SLOT_0_DATA_WIDTH } {
	# Procedure called to update C_SLOT_0_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_0_DATA_WIDTH { PARAM_VALUE.C_SLOT_0_DATA_WIDTH } {
	# Procedure called to validate C_SLOT_0_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_0_ADDR_WIDTH { PARAM_VALUE.C_SLOT_0_ADDR_WIDTH } {
	# Procedure called to update C_SLOT_0_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_0_ADDR_WIDTH { PARAM_VALUE.C_SLOT_0_ADDR_WIDTH } {
	# Procedure called to validate C_SLOT_0_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_0_BASEADDR { PARAM_VALUE.C_SLOT_0_BASEADDR } {
	# Procedure called to update C_SLOT_0_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_0_BASEADDR { PARAM_VALUE.C_SLOT_0_BASEADDR } {
	# Procedure called to validate C_SLOT_0_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_SLOT_0_HIGHADDR { PARAM_VALUE.C_SLOT_0_HIGHADDR } {
	# Procedure called to update C_SLOT_0_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_0_HIGHADDR { PARAM_VALUE.C_SLOT_0_HIGHADDR } {
	# Procedure called to validate C_SLOT_0_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_SLOT_1_ID_WIDTH { PARAM_VALUE.C_SLOT_1_ID_WIDTH } {
	# Procedure called to update C_SLOT_1_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_1_ID_WIDTH { PARAM_VALUE.C_SLOT_1_ID_WIDTH } {
	# Procedure called to validate C_SLOT_1_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_1_DATA_WIDTH { PARAM_VALUE.C_SLOT_1_DATA_WIDTH } {
	# Procedure called to update C_SLOT_1_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_1_DATA_WIDTH { PARAM_VALUE.C_SLOT_1_DATA_WIDTH } {
	# Procedure called to validate C_SLOT_1_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_1_ADDR_WIDTH { PARAM_VALUE.C_SLOT_1_ADDR_WIDTH } {
	# Procedure called to update C_SLOT_1_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_1_ADDR_WIDTH { PARAM_VALUE.C_SLOT_1_ADDR_WIDTH } {
	# Procedure called to validate C_SLOT_1_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SLOT_1_BASEADDR { PARAM_VALUE.C_SLOT_1_BASEADDR } {
	# Procedure called to update C_SLOT_1_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_1_BASEADDR { PARAM_VALUE.C_SLOT_1_BASEADDR } {
	# Procedure called to validate C_SLOT_1_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_SLOT_1_HIGHADDR { PARAM_VALUE.C_SLOT_1_HIGHADDR } {
	# Procedure called to update C_SLOT_1_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SLOT_1_HIGHADDR { PARAM_VALUE.C_SLOT_1_HIGHADDR } {
	# Procedure called to validate C_SLOT_1_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_SLOT_3_ID_WIDTH { MODELPARAM_VALUE.C_SLOT_3_ID_WIDTH PARAM_VALUE.C_SLOT_3_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_3_ID_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_3_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_3_DATA_WIDTH { MODELPARAM_VALUE.C_SLOT_3_DATA_WIDTH PARAM_VALUE.C_SLOT_3_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_3_DATA_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_3_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_3_ADDR_WIDTH { MODELPARAM_VALUE.C_SLOT_3_ADDR_WIDTH PARAM_VALUE.C_SLOT_3_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_3_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_3_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_2_ID_WIDTH { MODELPARAM_VALUE.C_SLOT_2_ID_WIDTH PARAM_VALUE.C_SLOT_2_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_2_ID_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_2_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_2_DATA_WIDTH { MODELPARAM_VALUE.C_SLOT_2_DATA_WIDTH PARAM_VALUE.C_SLOT_2_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_2_DATA_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_2_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_2_ADDR_WIDTH { MODELPARAM_VALUE.C_SLOT_2_ADDR_WIDTH PARAM_VALUE.C_SLOT_2_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_2_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_2_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIL_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXIL_DATA_WIDTH PARAM_VALUE.C_S_AXIL_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIL_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIL_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIL_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXIL_ADDR_WIDTH PARAM_VALUE.C_S_AXIL_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIL_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIL_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_0_ID_WIDTH { MODELPARAM_VALUE.C_SLOT_0_ID_WIDTH PARAM_VALUE.C_SLOT_0_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_0_ID_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_0_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_0_DATA_WIDTH { MODELPARAM_VALUE.C_SLOT_0_DATA_WIDTH PARAM_VALUE.C_SLOT_0_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_0_DATA_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_0_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_0_ADDR_WIDTH { MODELPARAM_VALUE.C_SLOT_0_ADDR_WIDTH PARAM_VALUE.C_SLOT_0_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_0_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_0_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_1_ID_WIDTH { MODELPARAM_VALUE.C_SLOT_1_ID_WIDTH PARAM_VALUE.C_SLOT_1_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_1_ID_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_1_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_1_DATA_WIDTH { MODELPARAM_VALUE.C_SLOT_1_DATA_WIDTH PARAM_VALUE.C_SLOT_1_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_1_DATA_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_1_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_1_ADDR_WIDTH { MODELPARAM_VALUE.C_SLOT_1_ADDR_WIDTH PARAM_VALUE.C_SLOT_1_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SLOT_1_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_SLOT_1_ADDR_WIDTH}
}

