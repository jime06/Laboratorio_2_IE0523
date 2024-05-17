`include "laboratorio2.v"
`include "tester_laboratorio2.v"

module laboratorio2_testbench;
//wires del testbench
wire clk, reset;
wire tarjeta_recibida, tipo_de_tarjeta;
wire [15:0] pin;
wire [4:0] digito;
wire digito_stb;
wire [31:0] monto;
wire tipo_trans, monto_stb;
wire balance_actualizado, entregar_dinero,fondos_insuficientes;
wire pin_incorrecto, bloqueo, advertencia;

laboratorio2 DUT(
    .clk(clk),
    .reset(reset),
    .tarjeta_recibida(tarjeta_recibida),
    .tipo_de_tarjeta(tipo_de_tarjeta),
    .pin(pin[15:0]),
    .digito(digito[4:0]),
    .digito_stb(digito_stb),
    .tipo_trans(tipo_trans),
    .monto(monto[31:0]),
    .monto_stb(monto_stb),
    .balance_actualizado(balance_actualizado),
    .entregar_dinero(entregar_dinero),
    .fondos_insuficientes(fondos_insuficientes),
    .pin_incorrecto(pin_incorrecto),
    .bloqueo(bloqueo),
    .advertencia(advertencia)
);

tester_laboratorio2 test(
    .clk(clk),
    .reset(reset),
    .tarjeta_recibida(tarjeta_recibida),
    .tipo_de_tarjeta(tipo_de_tarjeta),
    .pin(pin[15:0]),
    .digito(digito[4:0]),
    .digito_stb(digito_stb),
    .tipo_trans(tipo_trans),
    .monto(monto[31:0]),
    .monto_stb(monto_stb),
    .balance_actualizado(balance_actualizado),
    .entregar_dinero(entregar_dinero),
    .fondos_insuficientes(fondos_insuficientes),
    .pin_incorrecto(pin_incorrecto),
    .bloqueo(bloqueo),
    .advertencia(advertencia)
);

//se monitorea la actividad de las pruebas
initial begin
    $dumpfile("tb.vcd");
    $dumpvars;
end
endmodule