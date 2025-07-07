transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/mips_sc_org.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/mips.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/controller.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/maindec.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/aludec.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/datapath.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/regfile.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/adder.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/flopr.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/mux2.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/alu.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/muxBEQBNE.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/shifter.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/dmem.sv}
vlog -sv -work work +incdir+C:/Users/alexandre/Documents/Github/mips_single_cycle {C:/Users/alexandre/Documents/Github/mips_single_cycle/imem.sv}

