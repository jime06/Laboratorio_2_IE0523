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
    pin = 'h2023;

    //se prueba el primer pin
    //se ingresa el primer dígito
    #3 digito = 1;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //segundo dígito
    #3 digito = 2;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //tercer dígito
    #3 digito = 3;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //cuarto dígito
    #3 digito = 4;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //se ingresa el segundo pin
    #3 digito = 1;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //segundo dígito
    #3 digito = 1;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //tercer dígito
    #3 digito = 1;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //cuarto dígito
    #3 digito = 1;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //tercer pin
    #3 digito = 0;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //segundo dígito
    #3 digito = 0;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //tercer dígito
    #3 digito = 0;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //cuarto dígito
    #3 digito = 0;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //se bloquea el cajero y se reinicia
    #5 reset = 0;
    #5 reset = 1;

    //se ingresa el pin verdadero
    #3 digito = 2;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //segundo dígito
    #3 digito = 0;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //tercer dígito
    #3 digito = 2;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //cuarto dígito
    #3 digito = 3;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;
    //se autentica el usuario

    //se prueba el depósito
    tipo_trans = 0;

    //se ingresa el monto a depositar
    #3 monto = 100000;
    #1 monto_stb = 1;
    #monto_stb = 0;
    monto = 0;

    //se prueba el retiro
    #5 tipo_trans = 0;

    //se reinicia el cajero
    #5 reset = 0;
    #5 reset = 1;

    //se ingresa el pin correcto
    #3 digito = 2;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //segundo dígito
    #3 digito = 0;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //tercer dígito
    #3 digito = 2;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //cuarto dígito
    #3 digito = 3;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //se intenta un retiro con fondos insuficientes
    #3 monto = 1000000000;
    #1 monto_stb = 1;
    #1 monto_stb = 0;
    monto = 0;

    //se vuelve a ingresar el usuario y se reinicia el cajero con el tipo de transacción
    #5 tipo_trans = 1;
    #5 reset = 0;
    #5 reset = 1;

    //ingreso del código
    #3 digito = 2;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //segundo dígito
    #3 digito = 0;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //tercer dígito
    #3 digito = 2;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;

    //cuarto dígito
    #3 digito = 3;
    #1 digito_stb = 1;
    #1 digito_stb = 0;
    digito = 0;
    //se autentica el usuario y se procede con la transacción
    #3 monto = 9100;
    #1 monto_stb = 1;
    31 monto_stb = 0;
    monto = 0;

    #10;
    $finish;
end
endmodule