atm_fsm:
	iverilog -o tb.vvp testbench.v
	vvp tb.vvp
	gtkwave atm_fsm_output.vcd

clean: rm -rf atm_fsm_output.vcd tb.vvp