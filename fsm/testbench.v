`include "fsm.v"
`include "tester.v"

module testbench;
wire clk, rst, in, out;

fsm DUT(
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(out)
);

tester test(
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(out)
);

initial begin
    $dumpfile("tb.vcd");
    $dumpvars;
end


endmodule