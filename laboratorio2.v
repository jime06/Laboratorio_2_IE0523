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
  reg [0:1] state;
  reg [0:1] next_state;
  
  always @(posedge clk or negedge reset) begin
    if (rst)begin
      state => 3'b000; //esperando tarjeta
    end
    else begin
      state => next_state;
    end
  end

  always @(*)begin
    case(state)

      //estado inicial: esperando tarjeta
      3'b000:
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
          next_state = 3'b001; //pin acertado + deposito
        end
        else begin
          //si no, se queda esperando la tarjeta
          next_state = 3'b000;
          balance = '0;
        end
      end

      //primer estado: pin acertado + depósito
      3'b001:
      begin
        if (tipo_de_tarjeta && tarjeta_recibida)begin
          if(digito_stb)begin
            pin_usuario = {pin_usuario, digito};
            contador_pin = contador_pin + 1;
            //esto cuenta los digitos del pin
            //siempre que se estén ingresando dígitos este if se va a activar
            //la maquina se quedará en el mismo estado mientras espera otro digito
            next_state = 3'b001;
          end
          else begin
            //mientras digito esté en cero, se mantiene esperando el ingreso del dígito
            next_state = 3'b001;
          end
        
          //una vez ingresado el pin, este se verifica
          if (contador_pin == 4) begin
            if (pin_usuario == pin)begin
              //se resetea el pin
              pin_usuario = '0;
              contador_pin = 0;
              if(tipo_trans && !reset)begin
                //acá sumamos monto al balance
                balance_actualizado = 1;
              end
          end

            else begin
              //esto es lo que pasa cuando el pin es incorrecto
              //acá pasamos al estado pin incorrecto
          end 
        end
      end
    endcase
  end
endmodule
