# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "C_DATA_WIDTH" -widget comboBox
  ipgui::add_param $IPINST -name "C_ADDR_WIDTH"
  set C_S_AXIF_ID_WIDTH [ipgui::add_param $IPINST -name "C_S_AXIF_ID_WIDTH"]
  set_property tooltip {Width of ID for for write address, write data, read address and read data} ${C_S_AXIF_ID_WIDTH}
  set C_S_AXIF_AWUSER_WIDTH [ipgui::add_param $IPINST -name "C_S_AXIF_AWUSER_WIDTH"]
  set_property tooltip {Width of optional user defined signal in write address channel} ${C_S_AXIF_AWUSER_WIDTH}
  set C_S_AXIF_ARUSER_WIDTH [ipgui::add_param $IPINST -name "C_S_AXIF_ARUSER_WIDTH"]
  set_property tooltip {Width of optional user defined signal in read address channel} ${C_S_AXIF_ARUSER_WIDTH}
  set C_S_AXIF_WUSER_WIDTH [ipgui::add_param $IPINST -name "C_S_AXIF_WUSER_WIDTH"]
  set_property tooltip {Width of optional user defined signal in write data channel} ${C_S_AXIF_WUSER_WIDTH}
  set C_S_AXIF_RUSER_WIDTH [ipgui::add_param $IPINST -name "C_S_AXIF_RUSER_WIDTH"]
  set_property tooltip {Width of optional user defined signal in read data channel} ${C_S_AXIF_RUSER_WIDTH}
  set C_S_AXIF_BUSER_WIDTH [ipgui::add_param $IPINST -name "C_S_AXIF_BUSER_WIDTH"]
  set_property tooltip {Width of optional user defined signal in write response channel} ${C_S_AXIF_BUSER_WIDTH}

}

proc update_PARAM_VALUE.C_ADDR_WIDTH { PARAM_VALUE.C_ADDR_WIDTH } {
	# Procedure called to update C_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ADDR_WIDTH { PARAM_VALUE.C_ADDR_WIDTH } {
	# Procedure called to validate C_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to update C_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to validate C_DATA_WIDTH
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

proc update_PARAM_VALUE.C_S_AXIF_ID_WIDTH { PARAM_VALUE.C_S_AXIF_ID_WIDTH } {
	# Procedure called to update C_S_AXIF_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_ID_WIDTH { PARAM_VALUE.C_S_AXIF_ID_WIDTH } {
	# Procedure called to validate C_S_AXIF_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_AWUSER_WIDTH { PARAM_VALUE.C_S_AXIF_AWUSER_WIDTH } {
	# Procedure called to update C_S_AXIF_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_AWUSER_WIDTH { PARAM_VALUE.C_S_AXIF_AWUSER_WIDTH } {
	# Procedure called to validate C_S_AXIF_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_ARUSER_WIDTH { PARAM_VALUE.C_S_AXIF_ARUSER_WIDTH } {
	# Procedure called to update C_S_AXIF_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_ARUSER_WIDTH { PARAM_VALUE.C_S_AXIF_ARUSER_WIDTH } {
	# Procedure called to validate C_S_AXIF_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_WUSER_WIDTH { PARAM_VALUE.C_S_AXIF_WUSER_WIDTH } {
	# Procedure called to update C_S_AXIF_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_WUSER_WIDTH { PARAM_VALUE.C_S_AXIF_WUSER_WIDTH } {
	# Procedure called to validate C_S_AXIF_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_RUSER_WIDTH { PARAM_VALUE.C_S_AXIF_RUSER_WIDTH } {
	# Procedure called to update C_S_AXIF_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_RUSER_WIDTH { PARAM_VALUE.C_S_AXIF_RUSER_WIDTH } {
	# Procedure called to validate C_S_AXIF_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_BUSER_WIDTH { PARAM_VALUE.C_S_AXIF_BUSER_WIDTH } {
	# Procedure called to update C_S_AXIF_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_BUSER_WIDTH { PARAM_VALUE.C_S_AXIF_BUSER_WIDTH } {
	# Procedure called to validate C_S_AXIF_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_BASEADDR { PARAM_VALUE.C_S_AXIF_BASEADDR } {
	# Procedure called to update C_S_AXIF_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_BASEADDR { PARAM_VALUE.C_S_AXIF_BASEADDR } {
	# Procedure called to validate C_S_AXIF_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_HIGHADDR { PARAM_VALUE.C_S_AXIF_HIGHADDR } {
	# Procedure called to update C_S_AXIF_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_HIGHADDR { PARAM_VALUE.C_S_AXIF_HIGHADDR } {
	# Procedure called to validate C_S_AXIF_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXIF_ID_WIDTH { MODELPARAM_VALUE.C_S_AXIF_ID_WIDTH PARAM_VALUE.C_S_AXIF_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIF_ID_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIF_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIF_AWUSER_WIDTH { MODELPARAM_VALUE.C_S_AXIF_AWUSER_WIDTH PARAM_VALUE.C_S_AXIF_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIF_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIF_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIF_ARUSER_WIDTH { MODELPARAM_VALUE.C_S_AXIF_ARUSER_WIDTH PARAM_VALUE.C_S_AXIF_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIF_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIF_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIF_WUSER_WIDTH { MODELPARAM_VALUE.C_S_AXIF_WUSER_WIDTH PARAM_VALUE.C_S_AXIF_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIF_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIF_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIF_RUSER_WIDTH { MODELPARAM_VALUE.C_S_AXIF_RUSER_WIDTH PARAM_VALUE.C_S_AXIF_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIF_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIF_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIF_BUSER_WIDTH { MODELPARAM_VALUE.C_S_AXIF_BUSER_WIDTH PARAM_VALUE.C_S_AXIF_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIF_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIF_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_DATA_WIDTH { MODELPARAM_VALUE.C_DATA_WIDTH PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DATA_WIDTH}] ${MODELPARAM_VALUE.C_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_ADDR_WIDTH { MODELPARAM_VALUE.C_ADDR_WIDTH PARAM_VALUE.C_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_ADDR_WIDTH}
}

