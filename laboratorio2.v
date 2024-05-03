module laboratorio2(
  input clk,
  input reset,
  input tarjeta_recibida,
  input tipo_de_tarjeta,
  input [0:15] pin,
  input dígito,
  input digito_stb, //se pone en alto durante un ciclo de reloj cuando se presiona una tecla
  input tipo_trans,
  input [0:31] monto,
  input monto_stb,

  output reg balance_actualizado,
  output reg entregar_dinero,
  output reg fondos_insuficientes,
  output reg pin_incorrecto,
  output reg bloqueo,
  output reg advertencia
);
  //variables internas
  reg [0:63] balance;
  reg [0:2] contador_pin;//cuenta los digitos del pin ingresados al sistema
  reg [0:15] pin_usuario; //pin que digita el usuario
  always @(posedge clk or negedge reset)begin
    case(state) 
      /*primer caso: pin acertado + depósito*/
      if(tipo_de_tarjeta && tarjeta_recibida)begin
        //se pone en alto digito_stb por un ciclo de reloj y se actualiza el valor de digito
        if(digito_stb)begin
          pin_usuario = {pin_usuario, digito};
          contador_pin = contador_pin + 1;
        end

      end
    endcase
    
    case(state)
      /*segundo caso: pin acertado + retiro*/
    endcase

    case(state)
      /*tercer caso: pin incorrecto*/
    endcase
  end
endmodule
