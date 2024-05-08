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
   #2 clk = !clk;
end

//iniciamos las pruebas
initial begin
    clk = 0;
    reset = 1;
    tarjeta_recibida = 0;
    tipo_trans = 0;
    monto_stb = 0;
    pin = 15'b0;
    digito = 0;
    monto = 31'b0;

    //se inicia el cajero
    #1 reset = 0;
    #1 reset = 1;
    tarjeta_recibida = 1;
    //se prueba el recibido de tarjeta

end
endmodule