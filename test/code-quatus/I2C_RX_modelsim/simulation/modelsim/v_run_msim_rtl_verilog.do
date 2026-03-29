transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Code_FPGA/Do_An/New\ folder/RX_1 {D:/Code_FPGA/Do_An/New folder/RX_1/I2C_RX.v}

vlog -vlog01compat -work work +incdir+D:/Code_FPGA/Do_An/New\ folder/RX_1 {D:/Code_FPGA/Do_An/New folder/RX_1/tb_I2C_RX.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  tb_I2C_RX

add wave *
view structure
view signals
run -all
