fsm: 
	iverilog -o tb.vvp testbench.v 
	vvp tb.vvp
	gtkwave tb.vcd
	rm -rf tb.vvp tb.vcd

clean: 
	rm -rf tb.vvp tb.vcd