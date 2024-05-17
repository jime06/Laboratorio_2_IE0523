// Actual test code for the adder module
module tester
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
	TIPO_DE_TARJETA,
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
	TIPO_DE_TARJETA,
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
	#0 TIPO_DE_TARJETA = 0;
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
	   TIPO_DE_TARJETA = 1; //se va a probar el caso 1 primero (una tarjeta de un banco ajeno)
	   PIN			=	'h3443; //cambiar el pin luego

// Caso 1: tarjeta recibida + depósito:
	// 	en este caso se trabaja con una tarjeta de un banco ajeno
	// A.1:
	// 	Ingreso del pin
	
	// 	Primer dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Segundo dígito
	#3 DIGITO		=	4;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Tercer dígito
	#3 DIGITO		=	4;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Cuarto dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	//se autentica el usuario

	//se realiza el depósito
	   TIPO_TRANS		=	0;

	// 	Se ingresa el monto a depositar
	#3 MONTO		=	1000000000;
	#1 MONTO_STB		=	1;
	#1 MONTO_STB		=	0;
	   MONTO		=	0;
	// Depósito exitoso	

	//Finalmente, se resetea el cajero
	#0 TIPO_DE_TARJETA	=	0;
	#5 RESET = 0;
	#5 RESET = 1;

	#50;

	#0 TARJETA_RECIBIDA	=	0;
	#0 TIPO_DE_TARJETA = 0;
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
    TIPO_DE_TARJETA = 0; //se va a probar el caso 1 primero (una tarjeta de un banco ajeno)
    PIN			=	'h3443; //cambiar el pin luego

	//Caso 2: pin acertado + retiro:
	//es exactamente igual al caso 1, solo que en vez de deposito es retiro.
	//primero se prueba con fondos insuficientes
	// 	Ingreso del pin
	// 	Primer dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Segundo dígito
	#3 DIGITO		=	4;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Tercer dígito
	#3 DIGITO		=	4;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Cuarto dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	//se autentica el usuario
	//retiro con fondos insuficientes
	#3 MONTO = 1000000000000000;
	#1 MONTO_STB = 1;
	#1 MONTO_STB = 0;
		MONTO = 0;

	//se vuelve a ingresar el pin y se realiza
	#5 TIPO_TRANS = 1;
	#5 RESET = 0;
	#5 RESET = 1;

	//se ingresa el pin
	// 	Primer dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Segundo dígito
	#3 DIGITO		=	4;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Tercer dígito
	#3 DIGITO		=	4;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Cuarto dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;
	// se autentica el usuario
	//se procede a realizar el retiro con suficientes fondos
	#3 MONTO = 9100;
	#1 MONTO_STB = 1;
	#1 MONTO_STB = 0;
		MONTO = 0;

	// Caso 3: tarjeta recibida + pin incorrecto:
	// en este caso se trabaja con una tarjeta de un banco ajeno
	// A.1:
	// Ingreso del pin
	
	// Intento 1
	// 	Primer dígito
	#3 DIGITO		=	9;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Segundo dígito
	#3 DIGITO		=	8;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Tercer dígito
	#3 DIGITO		=	9;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Cuarto dígito
	#3 DIGITO		=	8;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;


	// Intento 2
// 	Primer dígito
	#3 DIGITO		=	5;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Segundo dígito
	#3 DIGITO		=	8;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Tercer dígito
	#3 DIGITO		=	7;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Cuarto dígito
	#3 DIGITO		=	0;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// Intento 3
	// 	Primer dígito
	#3 DIGITO		=	4;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Segundo dígito
	#3 DIGITO		=	7;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Tercer dígito
	#3 DIGITO		=	3;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	// 	Cuarto dígito
	#3 DIGITO		=	8;
	#1 DIGITO_STB		=	1;
	#1 DIGITO_STB		=	0;
	   DIGITO		=	0;

	#10 $finish;
end


endmodule

