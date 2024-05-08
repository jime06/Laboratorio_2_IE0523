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
  reg [1:0] intentos_pin;

  //variables de estados
  reg [0:2] state;
  reg [0:2] next_state;
  
  //definimos los estados como parámetros
  parameter esperando_tarjeta = 0; //default
  parameter hay_tarjeta = 1;
  parameter depósito = 2;
  parameter retiro = 3;
  parameter bloqueo = 4;

  always @(posedge clk) begin
    if (rst)begin
      next_state <= esperando_tarjeta;
    end
    else begin
      state => next_state;
    end
  end

  always @(*)begin
    case(state)

      //estado inicial: esperando tarjeta
      esperando_tarjeta:
      begin
        if(tarjeta_recibida == 1) begin
          balance_actualizado = 0;
          entregar_dinero = 0;
          fondos_insuficientes = 0;
          pin_incorrecto = 0;
          bloqueo = 0;
          advertencia = 0;
          contador_pin = '0;
          pin_usuario = '0;

          //se pasa de estado
          next_state = hay_tarjeta; //pin acertado + deposito
        end
        else begin
          //si no, se queda esperando la tarjeta
          next_state = esperando_tarjeta;
          balance = '0;
        end
      end

      //primer estado
      //hay_tarjeta:
      //begin

      //end
      
    endcase
  end
endmodule
