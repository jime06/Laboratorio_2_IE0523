module fsm (
    input clk, rst, in,
    output reg out
);

    //DEFINICION DE ESTADOS
    parameter  S0 = 0;
    parameter  S1 = 1;
    parameter  S2 = 2;

    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            out <= 0;
            state <= S0;
        end else begin
            state <= next_state;
        end
    end 

    always @(*) begin
        case (state)
            S0: begin
                out = 0;
                next_state = in ? S1 : S0;
            end
            S1: begin
                out = 1;
                next_state = in ? S2 : S0;
            end
            S2: begin
                out = 0;
                next_state = in ? S2 : S0;
            end
            default: begin
                out = 0;
                next_state = S0;
            end
        endcase
    end
endmodule