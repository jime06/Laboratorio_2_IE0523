module tester_laboratorio2(
    output clk,
    output reset,
    output tarjeta_recibida,
    output tipo_de_tarjeta,
    input [0:15] pin,
    output digito,
    output digito_stb,
    output tipo_trans,
    output [0:31] monto,
    output monto_stb,

    input balance_actualizado,
    input entregar_dinero,
    input fondos_insuficientes,
    input pin_incorrecto,
    input bloqueo,
    input advertencia
);

//acá definimos el clk
always begin
    clk = !clk;
end

//iniciamos las pruebas
initial begin
    
end
endmodule