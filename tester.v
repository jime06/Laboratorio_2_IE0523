// Actual test code for the adder module
module tester
	    (
	    CLK,
	    RESET,
	    TARJETA_RECIBIDA,
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



// Para el tester, se invierten las entradas y salidas respecto al DUT,
// esto para manipular el módulo que se estudia
// Declaración de entradas
input	// Todas las salidas son binarias
	BALANCE_ACTUALIZADO,
	ENTREGAR_DINERO,
	FONDOS_INSUFICIENTES,
	PIN_INCORRECTO,
	ADVERTENCIA,
	BLOQUEO;

// Declaración de salidas
output
	CLK,
	RESET,
	TARJETA_RECIBIDA,
	DIGITO_STB,
	TIPO_TRANS,
	MONTO_STB;
output [15:0] PIN;
output [3:0] DIGITO;
output [31:0] MONTO;

// Los roles de las señales también se invierten
// Declaración de roles para entradas
wire
	BALANCE_ACTUALIZADO,
	ENTREGAR_DINERO,
	FONDOS_INSUFICIENTES,
	PIN_INCORRECTO,
	ADVERTENCIA,
	BLOQUEO;

// Declaración de roles para salidas
reg
	CLK,
	RESET,
	TARJETA_RECIBIDA,
	DIGITO_STB,	// Será 1 cada vez que se ingrese el monto
	TIPO_TRANS,
	MONTO_STB;	// Será 1 cada vez que se ingrese un dígito
reg [15:0] PIN;	// Pin correcto dado por la tarjeta
reg [3:0] DIGITO;	// La entrada de dígito es volátil
reg [31:0] MONTO;	// Cantidad a operar en la transacción

// Definición de media frecuencia, en términos de unidades de tiempo
parameter h_freq=1;

// Señal de reloj
always begin
	#h_freq CLK = !CLK;
end

// Código de las pruebas
initial begin
	#0 CLK			=	0;
	#0 RESET		=	1;
	#0 TARJETA_RECIBIDA	=	0;
	#0 DIGITO_STB		=	0;
	#0 TIPO_TRANS		=	0;
	#0 MONTO_STB		=	0;
	#0 PIN			=	15'b0;
	#0 DIGITO		=	3'b0;
	#0 MONTO		=	31'b0;
	// Inicialización del cajero automático
	#1 RESET		=	0;
	#1 RESET		=	1;
	   TARJETA_RECIBIDA	=	1;
	   PIN			=	'h2023;
	// Inicio de la prueba A:
	// 	Autenticación del usuario
	// A.1:
	// 	Ingreso del primer pin
	// A.1.1:
	// 	Primer dígito
	#3 DIGITO		=	1;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.1.2:
	// 	Segundo dígito
	#3 DIGITO		=	2;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.1.3:
	// 	Tercer dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.1.4:
	// 	Cuarto dígito
	#3 DIGITO		=	4;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.2:
	// 	Ingreso del segundo pin
	// A.2.1:
	// 	Primer dígito
	#3 DIGITO		=	1;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.2.2:
	// 	Segundo dígito
	#3 DIGITO		=	1;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.2.3:
	// 	Tercer dígito
	#3 DIGITO		=	1;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.2.4:
	// 	Cuarto dígito
	#3 DIGITO		=	1;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.3:
	// 	Ingreso del tercer pin
	// A.3.1:
	// 	Primer dígito
	#3 DIGITO		=	0;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.3.2:
	// 	Segundo dígito
	#3 DIGITO		=	0;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.3.3:
	// 	Tercer dígito
	#3 DIGITO		=	0;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.3.4:
	// 	Cuarto dígito
	#3 DIGITO		=	0;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// El cajero queda bloqueado
	// A.4:
	// 	Se reinicia el cajero
	#5 RESET		=	0;
	#5 RESET		=	1;
	// A.5:
	// 	Ingreso del pin verdadero
	// A.5.1:
	// 	Primer dígito
	#3 DIGITO		=	2;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.5.2
	// 	Segundo dígito
	#3 DIGITO		=	0;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.5.3:
	// 	Tercer dígito
	#3 DIGITO		=	2;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// A.5.4:
	// 	Cuarto dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// El usuario queda autenticado
	// Se verifica que el cajero se bloquea
	// Fin de la prueba A
	
       	// Inicio de la prueba B:
	// 	Verificación de un depósito, se usa
	// 	la autenticación anterior
	// B.1:
	// 	Se selecciona el depósito
	// 	como tipo de transacción
	   TIPO_TRANS		=	0;
	// B.2:
	// 	Se ingresa el monto a depositar
	#3 MONTO		=	1000000000;
	#1 MONTO_STB		=	1;
	#1 MONTO_STB		=	0;
	   MONTO		=	0;
	// Depósito exitoso
	// Fin de la prueba B

	// Inicio de la prueba C:
	// 	Verificación del retiro, para fondos
	// 	suficientes e insuficientes
	// C.1:
	// 	Se selecciona el retiro
	// 	como tipo de transacción
	#5 TIPO_TRANS		=	1;
	// C.2:
	// 	Se reinicia el cajero
	#5 RESET		=	0;
	#5 RESET		=	1;
	// C.3:
	// 	Ingreso del pin verdadero
	// C.3.1:
	// 	Primer dígito
	#3 DIGITO		=	2;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// C.3.2
	// 	Segundo dígito
	#3 DIGITO		=	0;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// C.3.3:
	// 	Tercer dígito
	#3 DIGITO		=	2;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// C.3.4:
	// 	Cuarto dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// El usuario queda autenticado
	
	// C.4:
	// 	Se intenta un retiro con
	// 	fondos insuficientes	
	#3 MONTO		=	10000000000;
	#1 MONTO_STB		=	1;
	#1 MONTO_STB		=	0;
	   MONTO		=	0;
	
	// C.5:
	// 	Se vuelve a ingresar el usuario
	// 	Ingreso del pin verdadero
	// 	Se reinicia el cajero y se 
	// 	ingresa el tipo de transacción
	#5 TIPO_TRANS		=	1;
	#5 RESET		=	0;
	#5 RESET		=	1;
	// C.5.1:
	// 	Primer dígito
	#3 DIGITO		=	2;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// C.5.2
	// 	Segundo dígito
	#3 DIGITO		=	0;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// C.5.3:
	// 	Tercer dígito
	#3 DIGITO		=	2;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// C.5.4:
	// 	Cuarto dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// El usuario queda autenticado
	
	// C.6:
	// 	Se intenta un retiro con
	// 	fondos suficientes	
	#3 MONTO		=	916260902;
	#1 MONTO_STB		=	1;
	#1 MONTO_STB		=	0;
	   MONTO		=	0;
	
	#10 $finish;
end


endmodule

