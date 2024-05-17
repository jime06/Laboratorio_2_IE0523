module laboratorio2(
  input clk,
  input reset,
  input tarjeta_recibida,
  input tipo_de_tarjeta,
  input [15:0] pin,
  input [4:0] digito,
  input digito_stb, //se pone en alto durante un ciclo de reloj cuando se presiona una tecla
  input tipo_trans,
  input [31:0] monto,
  input monto_stb,

  output reg balance_actualizado,
  output reg entregar_dinero,
  output reg fondos_insuficientes,
  output reg pin_incorrecto,
  output reg bloqueo,
  output reg advertencia
  /*output reg tipo_de_tarjeta*/
);
  //variables internas
  reg [63:0] balance;
  reg [2:0] contador_pin;//cuenta los digitos del pin ingresados al sistema
  reg [15:0] pin_usuario; //pin que digita el usuario
  reg [1:0] intentos_pin;

  //variables de estados
  reg [5:0] state;
  reg [5:0] next_state;
  
  //definimos los estados como parámetros
  parameter esperando_tarjeta = 0; //default
  parameter esperando_pin = 1;
  parameter usuario_identificado = 2;
  parameter deposito = 3;
  parameter retiro = 4;
  parameter bloqueado = 5;

  always @(posedge clk) begin
    if (!reset)begin
      state <= next_state;
    end
    else begin
      state <= esperando_tarjeta;
    end
  end

  always @(*)begin
    case(state)

      //estado inicial: esperando tarjeta
      esperando_tarjeta:
      begin
        if(tarjeta_recibida == 1) begin
        //Cuando se ingresa una tarjeta que no es del bcr, tipo_de_tarjeta se pone en y se cobra una comisión
          if (tipo_de_tarjeta == 1) begin
            balance = balance - 1000;
            next_state = esperando_tarjeta;
            //como en la vida real, se descuenta la comisión y se pasa a pedir el pin
          end

          else begin
            //en el caso de que la tarjeta sí es bcr, no se cobra la comision y se procede.
            balance_actualizado = 0;
            entregar_dinero = 0;
            fondos_insuficientes = 0;
            pin_incorrecto = 0;
            bloqueo = 0;
            advertencia = 0;
            contador_pin = 0;
            pin_usuario = 0;
            intentos_pin = 0;
            //balance = 1000000;
            next_state = esperando_pin;//pin acertado + deposito
          end
        end
        else begin
          //si no, se queda esperando la tarjeta
          next_state = esperando_tarjeta;
          balance <= 0;
        end
      end

      //primer estado
      esperando_pin:
      begin
        if(digito_stb) begin
          pin_usuario = {pin_usuario, digito}; //acá está mi problema
          contador_pin = contador_pin + 1;

          next_state = esperando_pin; //se vuelve a esperando_pin para esperar el siguiente dígito
        end
        else begin
          //mientras digito_stb esté en cero se mantendrá esperando el ingreso del digito
          next_state = esperando_pin;
        end

        //una vez que se ingresó el pin, se verifica si es válido o no
        if(contador_pin == 4) begin
          if(pin_usuario == pin)begin
            //el pin ingresado es el correcto y se identifica el usuario
            pin_usuario = 0;
            contador_pin = 0; //se reinicia el contador
            next_state = usuario_identificado;
          end
          else begin
            contador_pin = 0;
            intentos_pin = intentos_pin + 1;
            pin_incorrecto = 1; //se ingresa el pin incorrecto una vez

            if(intentos_pin == 2)begin
              advertencia = 1;
              next_state = esperando_pin;
            end
            else if(intentos_pin == 3) 
              next_state = bloqueado;
            else
              next_state = esperando_pin;
          end
        end
        else begin
          next_state = esperando_pin; //se ingresa el pin incorrecto una vez
        end
      end

      //segundo estado
      usuario_identificado:
      begin
        //una vez que se identifica el usuario, se define el tipo de transacción
        if(tipo_trans) 
          next_state = retiro;
        else
          next_state = deposito;
      end

      //tercer estado
      deposito:
      begin
        if (monto_stb) begin
          //se le suma el monto depositado al balance de la cuenta
          balance = balance + monto;
          balance_actualizado = 1;
          //se vuelve a esperar a que se ingrese el pin
          next_state = esperando_tarjeta;
        end
        else
          next_state = deposito;
      end

      // cuarto estado
      retiro:
      begin
        if (monto_stb) begin
          if (balance > monto) begin
            balance = balance + -monto;
            balance_actualizado = 1;
            entregar_dinero = 1;
            next_state = esperando_tarjeta;
          end
          else begin
            fondos_insuficientes = 1;
            next_state = esperando_tarjeta;
          end
        end
        /*else begin
          next_state = retiro;
        end*/
      end

      //quinto estado
      bloqueado:
      begin
        //cuando se bloquea la tarjeta, se mantiene bloqueada
        bloqueo = 1;
        next_state = bloqueado;
      end

      //estado default
      default:
      begin
        next_state = esperando_tarjeta;
      end      
    endcase
  end
endmodule
