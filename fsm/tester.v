`timescale 1ns/1ns

module tester (
    output reg clk, rst, in,
    input out
);

always begin
    #2 clk = !clk;
end

initial begin
    clk = 0;
    rst = 1;
    in = 0;

    #14;

    rst = 0;
    in = 1;
    #14;
    in = 0;
    #40;
    in = 1;
    #14;
    in = 0;
    #14;

    $finish;
end



endmodule