module laboratorio2(
  input clk,
  input reset,
  input tarjeta_recibida,
  input tipo_de_tarjeta,
  input pin,
  input dígito,
  input digito_stb, //se pone en alto durante un ciclo de reloj cuando se presiona una tecla
  input tipo_trans,
  input monto,
  input monto_stb,

  output reg balance_actualizado,
  output reg entregar_dinero,
  output reg fondos_insuficientes,
  output reg pin_incorrecto,
  output reg bloqueo,
  output reg advertencia
);
  reg [0:63] balance;
  always @(posedge clk or negedge reset)begin
    case(state) 
      /*primer caso: pin acertado + depósito*/
      if(tipo_de_tarjeta && tarjeta_recibida)begin
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
