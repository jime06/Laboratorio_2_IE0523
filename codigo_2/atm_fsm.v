// Declaración del módulo y parámetros
module atm //#()
	    (    
	    CLK,
	    RESET,
	    TARJETA_RECIBIDA,
		TIPO_DE_TARJETA,
	    PIN,
	    DIGITO,
	    DIGITO_STB,
	    TIPO_TRANS,
	    MONTO,
	    MONTO_STB,
	    BALANCE_ACTUALIZADO,
	    ENTREGAR_DINERO,
	    FONDOS_INSUFICIENTES,
	    PIN_INCORRECTO,
	    ADVERTENCIA,
	    BLOQUEO
    	    );

// Declaración de entradas y salidas
input
	CLK,
	RESET,
	TARJETA_RECIBIDA,
	TIPO_DE_TARJETA,
	DIGITO_STB,
	TIPO_TRANS,
	MONTO_STB;
input [15:0] PIN;
input [3:0] DIGITO;
input [31:0] MONTO;

output	// Todas las salidas son binarias
	BALANCE_ACTUALIZADO,
	ENTREGAR_DINERO,
	FONDOS_INSUFICIENTES,
	PIN_INCORRECTO,
	ADVERTENCIA,
	BLOQUEO;

// Declaración de roles para entradas
wire
	CLK,
	RESET,
	TARJETA_RECIBIDA,
	TIPO_DE_TARJETA,
	DIGITO_STB,	// Será 1 cada vez que se ingrese el monto
	TIPO_TRANS,
	MONTO_STB;	// Será 1 cada vez que se ingrese un dígito
wire [15:0] PIN;	// Pin correcto dado por la tarjeta
wire [3:0] DIGITO;	// La entrada de dígito es volátil
wire [31:0] MONTO;	// Cantidad a operar en la transacción

// Declaración de roles para salidas
reg
	BALANCE_ACTUALIZADO,
	ENTREGAR_DINERO,
	FONDOS_INSUFICIENTES,
	PIN_INCORRECTO,
	ADVERTENCIA,
	BLOQUEO;


// Declaración de variables internas
reg [63:0] BALANCE;	// Dinero en la cuenta
reg [1:0] Intentos_PIN;	// Contador de intentos fallidos para verificar la tarjeta
reg [2:0] Contador_PIN;	// Contador de dígitos del pin ingresados al sistema
reg [15:0] PIN_usuario;	// Ping tentativo que digita el usuario

// Declaración de vectores de estados
reg [5:0] estado_actual;
reg [5:0] prox_estado;

// Definir todos los flip flops
// Se encarga de pasar del estado actual al estado siguiente
always @(posedge CLK) begin
	// La señal de reinicio funciona invertida, si RESET == 1,
	// el cajero funciona bien, caso contrario pasa al estado
	// 6'b000001
	if (~RESET) begin
		estado_actual	<=	6'b000001;
	end else begin
		estado_actual  	<=	prox_estado;
	end
end

// Lógica combinacional que se encarga
// de la transición de estados
// El bloque crea flip flops, se usan
// asignaciones no bloqueantes, salvo
// para prox_estado porque esa señal
// se actualiza cada ciclo de reloj
// y ahí se usan asignaciones no 
// bloqueantes
always @(*) begin
	case (estado_actual)
		// Estado 0: Esperando tarjeta
		6'b000001:
		begin
			// Se evalúa si se ingresó la tarjeta para pasar
			// o no de estado
			if (TARJETA_RECIBIDA == 1 && TIPO_DE_TARJETA == 0) begin
				// Se ingresa una tarjeta y esta es del bcr
				BALANCE_ACTUALIZADO	=	0;
				ENTREGAR_DINERO		=	0;
				FONDOS_INSUFICIENTES	=	0;
				PIN_INCORRECTO		=	0;
				ADVERTENCIA		=	0;
				BLOQUEO			=	0;
				PIN_usuario		=	'0;
				Contador_PIN		=	'0;
				Intentos_PIN		=	'0;
				// Finalmente, se pasa al estado
				prox_estado	=	6'b000010;

			end else if (TARJETA_RECIBIDA == 1 && TIPO_DE_TARJETA == 1)begin
				// Se recibe una tarjeta de otro banco
				BALANCE_ACTUALIZADO	=	0;
				ENTREGAR_DINERO		=	0;
				FONDOS_INSUFICIENTES	=	0;
				PIN_INCORRECTO		=	0;
				ADVERTENCIA		=	0;
				BLOQUEO			=	0;
				PIN_usuario		=	'0;
				Contador_PIN		=	'0;
				Intentos_PIN		=	'0;
				//se cobra la comisión
				BALANCE = BALANCE - 2;
				BALANCE_ACTUALIZADO = 1;
				//se pasa al próximo estado
				prox_estado = 6'b000010;
				//prox_estado	=	6'b000001;
				//BALANCE		<=	'0;
			end else begin
				//no hay tarjeta y se queda esperando que se ingrese una
				prox_estado	=	6'b000001;
				BALANCE		<=	'0;
			end
		end

		// Estado 1: Esperando PIN, se encarga de esperar a que se
		// ingrese el PIN dígito a dígito, después verifica si la
		// entrada del usuario corresponde con el dato dado por la
		// tarjeta, si es correcto pasa a autenticar el usuario, si
		// falla, aumenta el número de intentos y penaliza según se
		// requiera
		6'b000010:
		begin
			// Se empieza por ingresar el PIN dígito a dígito
			if (DIGITO_STB) begin
				// Se concatenan los últimos dígitos del PIN
				PIN_usuario = {PIN_usuario, DIGITO}; 
				Contador_PIN = Contador_PIN + 1; // Contador_PIN++
				// Una vez ingresado el pin, se asigna el
				// estado actual a volver a ingresar el pin,
				// así, si se ya se han introducido
				// suficientes dígitos, se verificará la
				// entrada, y si no, los if restantes no se
				// activarán y de volverá a esperar el
				// siguiente dígito
				prox_estado = 6'b000010;
			end else begin
				// Mientras DIGITO_STB esté en cero, se
				// mantiene esperando el ingreso
				prox_estado = 6'b000010;
			end
			
			// Se verifica si la cantidad de dígitos ingresados es
			// 4
			if (Contador_PIN == 4) begin
				// Si hay 4 dígitos, se pasa a verificar si es
				// válido o no
				if (PIN_usuario == PIN) begin
					// Se borra el pin ingresado
					PIN_usuario = '0;
					Contador_PIN = 0; // Reinicia el contador
					prox_estado = 6'b001000;
				end else begin
					Contador_PIN = 0; // Reinicia el contador
					Intentos_PIN = Intentos_PIN + 1;
					PIN_INCORRECTO = 1;
					// No es necesario reiniciar el pin
					// porque el contador de dígitos
					// ingresados vuelve a cero, así que
					// necesariamente se necesitan 4 bits
					// nuevos para volver a comprobar.
					// Ahora, por tener de redundancia 
					// se puede agregar también
					if (Intentos_PIN == 2) begin
						ADVERTENCIA = 1;
						prox_estado = 6'b000010;
					end else if (Intentos_PIN == 3) begin
						prox_estado = 6'b000100;
					end else begin
						// Sucede cuando sólo hay un
						// intento
						prox_estado = 6'b000010;
					end
				end
			end else begin
				// Si hay menos de 4 dígitos ingresados, se
				// mantiene esperando los demás
				prox_estado = 6'b000010;
			end
		end
		// Estado 2: Bloqueado
		6'b000100:
		begin
			// Cuando se bloquea,se mantiene bloqueado
			BLOQUEO = 1;
			prox_estado = 6'b000100;
		end
		// Estado 3: Usuario identificado
		6'b001000:
		begin
			// Con el usuario identificado, se pasa a esperar qué
			// tipo de transacción se desea y se pasa a ella
			if (TIPO_TRANS) begin
				// Se pasa a retiro cuando se ingresa un 1
				prox_estado = 6'b010000;
			end else begin
				// Si se ingresa un 0, se pasa a depósito
				prox_estado = 6'b100000;
			end

		end
		// Estado 4: Retiro: retira dinero del balance, verifica si el
		// monto ingresado es menor al balance de la cuenta
		6'b010000:
		begin

			// Espera a que se digite el monto para realizar la
			// transacción
			if (MONTO_STB) begin
				if (BALANCE > MONTO) begin
					// Si es posible retirar la cantidad
					// solicitada, se procede con la
					// transacción
					BALANCE = BALANCE + -MONTO;
					BALANCE_ACTUALIZADO = 1;
					ENTREGAR_DINERO = 1;
					// Al final, se vuelve a esperar que se
					// ingrese el pin
					prox_estado = 6'b0000001;
				end else begin
					// Si no hay suficientes fondos en la
					// cuenta, se indica que no los hay
					// y se vuelve a esperar el ingreso
					// del pin
					FONDOS_INSUFICIENTES = 1;
					prox_estado = 6'b000001;
				end
			end 
		end
		// Estado 5: Depósito: ingresa dinero al balance
		6'b100000:
		begin
			// Espera a que se digite el monto para realizar la
			// transacción
			if (MONTO_STB) begin
				BALANCE = BALANCE + MONTO;
				BALANCE_ACTUALIZADO = 1;
				// Al final, se vuelve a esperar que se
				// ingrese el pin
				prox_estado = 6'b000001;
			end
		end

		default:
		begin 
			prox_estado = 6'b000001;
		end
	endcase
end

endmodule
