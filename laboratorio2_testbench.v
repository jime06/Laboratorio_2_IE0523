`include "laboratorio2.v"
`include "tester_laboratorio2.v"

module laboratorio2_testbench;
//wires del testbench
laboratorio2 DUT(
    .clk(clk),
    .reset(reset)
    .tarjeta_recibida(tarjeta_recibida),
    .tipo_de_tarjeta(tipo_de_tarjeta),
    .pin(pin[0:15]),
    .digito(digito),
    .digito_stb(digito_stb),
    .tipo_trans(tipo_trans),
    .monto(monto),
    .monto_stb(monto_stb),
    .balance_actualizado(balance_actualizado),
    .entregar_dinero(entregar_dinero),
    .fondos_insuficientes(fondos_insuficientes),
    .pin_incorrecto(pin_incorrecto),
    .bloqueo(bloqueo),
    .advertencia(advertencia)
);
endmodule