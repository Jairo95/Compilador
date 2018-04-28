/***
ESCUELA POLITÉCNICA NACIONAL
INGENIERÍA DE SISTEMAS
COMPILADORES 
PROYECTO SEGUNDO BIMESTRE - ETAPA 2: ANALIZADOR SINTÁCTICO
ANALIZADOR LÉXICO
	Johanna Arias
	Samantha De la Cruz
FECHA: a 2016/06/30
GR_02
***/

	/*** Sección de declaraciones ***/
%{
	#include <stdio.h>// para usar printf en las reglas
	#include <stdlib.h> 
	#include <stdbool.h>
	#include <string.h>

	#include "semantico.h"
	//#include "lex.yy.c"

	extern FILE *yyin;
	extern int yylex();
	extern void yyerror(const char *);
	extern int linea;

	int band = 1;

	FILE *archSal;//para imprimir codgen
	ptr_tab tablaSimbolos;
	

	void inicializarTabla(void);
	ptr_exp inicializarExpresion(void);

	
	
%}

/*Declarations*/
%union {
	int 		ival;   	    //tipo de numero
	float		dval;
	char    	cval;  		    //tipo de simbolo
	char*       	sval;   	    //tipo de identificador
	ptr_sym     	symptr; 	    //puntero a la tabla de simbolos
	ptr_exp		exptr;		//puntero al resultado operaciones
}

	//declaraciones de símbolos de gramática terminales
	//los no t erminales irían con %type

%start programa //indica el símbolo de inicio de la gramática

%token <sval> INCLUDE LIBRERIA
%token <sval> TD_INT TD_FLOAT TD_CHAR TD_STRING TD_BOOL
%token <sval> IF FOR ELSE RETURN VOID THEN WHILE DO INPUT OUTPUT
%token <ival> ENTEROPOSITIVO ENTERONEGATIVO
%token <dval> FLOAT
%token <sval> BOOL
%token <cval> CARACTER_ESPECIAL
%token <sval> COMPARATIVOS
%token <symptr> IDENTIFICADOR
%token <cval> CHAR 
%token <sval> STRING
%token <cval> MAS MENOS MULTIPLICACION DIVISION
%token <cval> COMA DOS_PUNTOS LLAV_ABIERTA LLAV_CERRADA PAR_ABIERTO PAR_CERRADO COR_ABIERTO COR_CERRADO PUNTO_Y_COMA IGUAL

%type <ival> tipoDeDato
%type <exptr> operacion factor termino

%%

programa:
	sentencia			
	|programa sentencia
	;

sentencia:
	declaracion_libreria 				{printf("declaracion_Libreria\n");}
	|declaracion_variable PUNTO_Y_COMA		{printf("declaracion_Variable\n");}
	|declaracion_variable_compuesta PUNTO_Y_COMA	{printf("declaracion_Variable_compuesta\n");}
	|declaracion_vector PUNTO_Y_COMA		{printf("declaracion_Vector\n");}
	|asignacion PUNTO_Y_COMA			{printf("Asignacion_valores\n");}
	|funcion					{printf("Declaracion funcion\n");}
	|control_flujo					{printf("Control_de_flujo");}
	;

declaracion_libreria:
	INCLUDE LIBRERIA	
	;

declaracion_variable:
	tipoDeDato DOS_PUNTOS IDENTIFICADOR	{
						ptr_sym simbolo = $3;
						if(getSimbolo(tablaSimbolos, simbolo->nombre)){
							printf("Warning: Ya existe una declaracion para esta variable: Linea: %d\n", linea);
						} else {
							simbolo->tipoDato = $1;
							insertarSimbolos(tablaSimbolos, simbolo);
							
						}

						}
	;

declaracion_variable_compuesta:
	tipoDeDato DOS_PUNTOS IDENTIFICADOR IGUAL operacion	{/*
						ptr_sym simbolo = $3;
						printf("Reconoce declaracion y asignacion\n");
						if(getSimbolo(tablaSimbolos, simbolo->nombre)){
							printf("ya existe variable\n");
						} else {
							simbolo->tipoDato = $1;
							simbolo->valor.entero = $5;
							insertarSimbolos(tablaSimbolos, simbolo);
							printf("simbolo insertado\n");
						}*/

						}
	;

asignacion:
	IDENTIFICADOR IGUAL operacion		{
						ptr_sym simbolo = $1;
						ptr_exp expresion = $3;
						
						if(getSimbolo(tablaSimbolos, simbolo->nombre)){ // Ya existe el simbolo
							simbolo = getNodoSimbolo(tablaSimbolos, simbolo->nombre);
							//printf("Tipo de dato:S %d, E %d\n", simbolo->tipoDato, expresion->tipoDato);
							if(simbolo->tipoDato == expresion->tipoDato){ // Coincide la definicion de tipo con  operacion
								// Se remplaza el valor que tenia
								cambiarValor(tablaSimbolos, simbolo->nombre, simbolo->tipoDato, expresion);
								fprintf(archSal,"loadAI  $r2,  -4  =>  $sp\n");
							} else {
								printf("Warning: Tipos incompatibles: Linea: %d\n", linea);
							}
						} else {
							printf("Error: Variable sin declarar: Linea: %d\n", linea);
						}

						}
	;


/* Operaciones matematicas */

operacion:
	operacion MAS termino 			{ // Suma entre 2 numeros, entero, flotante
						ptr_exp resultado = inicializarExpresion();
						ptr_exp expresion1 = $1;
						ptr_exp expresion2 = $3;
						int tipoDato1 = expresion1->tipoDato, tipoDato2 = expresion2->tipoDato;
						// Se realiza la inferencia de tipo
						if (tipoDato1 == tipoDato2 && tipoDato1 == 1){ //Entero + Entero = Entero
							resultado->tipoDato = tipoDato1;
							resultado->entero = expresion1->entero + expresion2->entero;

							fprintf(archSal,"loadAI  $t1,  -4  =>  $sp\n");
							fprintf(archSal,"add  $a0,  $t1  =>  $0\n");
							//pop
							fprintf(archSal,"addI  $sp,  -4  =>  $sp\n");
							//push
							fprintf(archSal,"storeAI  $sp  =>  $a0,  0\n");
							fprintf(archSal,"addI  $sp,  4  =>  $sp\n");

						}
						if (tipoDato1 == tipoDato2 && tipoDato1 == 2){ //Flotante + Flotante = Flotante
							resultado->tipoDato = tipoDato1;
							resultado->flotante = expresion1->flotante + expresion2->flotante;
						}
						if (tipoDato1 != tipoDato2 && tipoDato1 == 1 && tipoDato2 == 2){ //Entero + Flotante = Flotante
							resultado->tipoDato = tipoDato2;
							resultado->flotante = (float)expresion1->entero + expresion2->flotante;
						}
						if (tipoDato1 != tipoDato2 && tipoDato1 == 2 && tipoDato2 == 1){ //Flotante - Entero = Flotante
							resultado->tipoDato = tipoDato1;
							resultado->flotante = expresion1->flotante + (float)(expresion2->entero);
						}
						//printf("Tipo de dato suma: %d\n", resultado->tipoDato);
						$$ = resultado;
						}
	|operacion MENOS termino 		{// Resta entre 2 numeros, entero, flotante
						ptr_exp resultado = inicializarExpresion();
						ptr_exp expresion1 = $1;
						ptr_exp expresion2 = $3;
						int tipoDato1 = expresion1->tipoDato, tipoDato2 = expresion2->tipoDato;
						//Inferencia de tipo
						if (tipoDato1 == tipoDato2 && tipoDato1 == 1){ //Entero - Entero = Entero
							resultado->tipoDato = tipoDato1;
							resultado->entero = expresion1->entero - expresion2->entero;

							fprintf(archSal,"loadAI  $t1,  -4  =>  $sp\n");
							fprintf(archSal,"sub  $a0,  $t1  =>  $0\n");
							//pop
							fprintf(archSal,"addI  $sp,  -4  =>  $sp\n");
							//push
							fprintf(archSal,"storeAI  $sp  =>  $a0,  0\n");
							fprintf(archSal,"addI  $sp,  4  =>  $sp\n");
						}
						if (tipoDato1 == tipoDato2 && tipoDato1 == 2){ //Flotante - Flotante = Flotante
							resultado->tipoDato = tipoDato1;
							resultado->entero = expresion1->flotante - expresion2->flotante;
						}
						if (tipoDato1 != tipoDato2 && tipoDato1 == 1 && tipoDato2 == 2){ //Entero - Flotante = Flotante
							resultado->tipoDato = tipoDato2;
							resultado->flotante = (float)(expresion1->entero) - expresion2->flotante;
						}
						if (tipoDato1 != tipoDato2 && tipoDato1 == 2 && tipoDato2 == 1){ //Flotante - Entero = Flotante
							resultado->tipoDato = tipoDato1;
							resultado->flotante = expresion1->flotante - (float)(expresion2->entero);
						}
							
						$$ = resultado;
						}
	|termino 				{$$ = $1;
						//printf("Sintactico 2: %s\n", $1->string);
						}
		;

termino:termino MULTIPLICACION factor 		{ // Multiplicacion entre 2 numeros, entero, flotante
						ptr_exp resultado = inicializarExpresion();
						ptr_exp expresion1 = $1;
						ptr_exp expresion2 = $3;
						int tipoDato1 = expresion1->tipoDato, tipoDato2 = expresion2->tipoDato;
						if (tipoDato1 == tipoDato2 && tipoDato1 == 1){
							resultado->tipoDato = tipoDato1;
							resultado->entero = expresion1->entero * expresion2->entero;

							fprintf(archSal,"loadAI  $t1,  -4  =>  $sp\n");
							fprintf(archSal,"mult  $a0,  $t1  =>  $0\n");
							//pop
							fprintf(archSal,"addI  $sp,  -4  =>  $sp\n");
							//push
							fprintf(archSal,"storeAI  $sp  =>  $a0,  0\n");
							fprintf(archSal,"addI  $sp,  4  =>  $sp\n");

						}
						if (tipoDato1 == tipoDato2 && tipoDato1 == 2){
							resultado->tipoDato = tipoDato1;
							resultado->entero = expresion1->flotante * expresion2->flotante;
						}
						if (tipoDato1 != tipoDato2 && tipoDato1 == 1 && tipoDato2 == 2){
							resultado->tipoDato = tipoDato2;
							resultado->flotante = (float)(expresion1->entero) * expresion2->flotante;
						}
						if (tipoDato1 != tipoDato2 && tipoDato1 == 2 && tipoDato2 == 1){
							resultado->tipoDato = tipoDato1;
							resultado->flotante = expresion1->flotante * (float)(expresion2->entero);
						}
						$$ = resultado;
						}
	|termino DIVISION factor	 	{ // Division entre 2 numeros, entero, flotante
						ptr_exp resultado = inicializarExpresion();
						ptr_exp expresion1 = $1;
						ptr_exp expresion2 = $3;
						int tipoDato1 = expresion1->tipoDato, tipoDato2 = expresion2->tipoDato;
						if (tipoDato1 == tipoDato2 && tipoDato1 == 1 && expresion2->entero != 0){
							resultado->tipoDato = tipoDato1;
							resultado->entero = expresion1->entero / expresion2->entero;

							fprintf(archSal,"loadAI  $t1,  -4  =>  $sp\n");
							fprintf(archSal,"add  $a0,  $t1  =>  $0\n");
							//pop
							fprintf(archSal,"addI  $sp,  -4  =>  $sp\n");
							//push
							fprintf(archSal,"storeAI  $sp  =>  $a0,  0\n");
							fprintf(archSal,"addI  $sp,  4  =>  $sp\n");
						}
						if (tipoDato1 == tipoDato2 && tipoDato1 == 2 && expresion2->flotante != 0.0){
							resultado->tipoDato = tipoDato1;
							resultado->entero = expresion1->flotante / expresion2->flotante;
						}
						if (tipoDato1 != tipoDato2 && tipoDato1 == 1 && tipoDato2 == 2 && expresion2->flotante != 0.0){
							resultado->tipoDato = tipoDato2;
							resultado->flotante = (float)(expresion1->entero) / expresion2->flotante;
						}
						if (tipoDato1 != tipoDato2 && tipoDato1 == 2 && tipoDato2 == 1 && expresion2->entero != 0){
							resultado->tipoDato = tipoDato1;
							resultado->flotante = expresion1->flotante / (float)(expresion2->entero);
						}
						$$ = resultado;
						}
	|factor  				{$$ = $1;}
	;

// Valores base: Entero = 1, flotante = 2, Char = 3, String = 4, Boolean = 5
factor:	PAR_ABIERTO operacion PAR_CERRADO  	{$$ = $2;}
	|ENTERONEGATIVO				{
						ptr_exp expresion = inicializarExpresion();
						expresion->entero = $1;
						expresion->tipoDato = 1;
						$$ = expresion;
						
						
						if(band!=1){
							//push
							fprintf(archSal,"storeAI  $sp  =>  $a0,  0\n");
							fprintf(archSal,"addI  $sp,  4  =>  $sp\n");
						}
						band = 2;
						fprintf(archSal,"loadI  %d =>  $a0\n", $1);
						}
	|ENTEROPOSITIVO		   		{
						ptr_exp expresion = inicializarExpresion();
						expresion->entero = $1;
						expresion->tipoDato = 1;
						//printf("Tipo de dato: %d\n", expresion->tipoDato);
						$$ = expresion;

						if(band!=1){
							//push
							fprintf(archSal,"storeAI  $sp  =>  $a0,  0\n");
							fprintf(archSal,"addI  $sp,  4  =>  $sp\n");
						}
						band = 2;
						fprintf(archSal,"loadI  %d =>  $a0\n", $1);
						}
	|FLOAT					{
						ptr_exp expresion = inicializarExpresion();
						expresion->flotante = $1;
						expresion->tipoDato = 2;
						//printf("Lee valores? Valor: %f\n", expresion->flotante);
						$$ = expresion;
						}
	|IDENTIFICADOR				{
						ptr_exp expresion = inicializarExpresion();
						ptr_sym simbolo = $1;
						if(getSimbolo(tablaSimbolos, simbolo->nombre)){
							simbolo = getNodoSimbolo(tablaSimbolos, simbolo->nombre);
							expresion->tipoDato = simbolo->tipoDato;
							switch(expresion->tipoDato){
							case 1:
								expresion->entero = simbolo->valor.entero;
								break;
							case 2:
								expresion->flotante = simbolo->valor.flotante;
								break;
							case 3:
								expresion->caracter = simbolo->valor.caracter;
								break;
							case 4:
								expresion->string = simbolo->valor.cadena;
								break;
							case 5:
								expresion->boolean = simbolo->valor.boolean;
								break;
							}

						} else { 
							printf("Error: Variable sin declarar: Linea: %d\n", linea);
						
						}
						
						$$ = expresion;
						}
	|STRING					{
						ptr_exp expresion = inicializarExpresion();
						// printf("Sintactico: %s\n", $1);
						expresion->string = strdup($1);
						expresion->tipoDato = 4;
						//printf("Sintactico: %s\n", expresion->string);
						$$ = expresion;
						}
	|CHAR					{
						ptr_exp expresion = inicializarExpresion();
						expresion->caracter = $1;
						expresion->tipoDato = 3;
						//printf("Valor char: %c\n", expresion->caracter);
						$$ = expresion;
						}
	|BOOL					{
						ptr_exp expresion = inicializarExpresion();
						expresion->boolean = $1;
						expresion->tipoDato = 5;
						//printf("Valor bool: %f\n", expresion->boolean);
						$$ = expresion;
						}
	;

/*  -------------   */
declaracion_vector:
	tipoDeDato DOS_PUNTOS IDENTIFICADOR COR_ABIERTO ENTEROPOSITIVO COR_CERRADO//string  adf [5]
	;

funcion:tipoDeDato DOS_PUNTOS IDENTIFICADOR PAR_ABIERTO lista_parametros PAR_CERRADO bloque
	;

lista_parametros:
	|lista_parametros COMA declaracion_variable
	|declaracion_variable
	|' '
	;

bloque:	LLAV_ABIERTA comando_simple LLAV_CERRADA
	;

comando_simple:
	programa
	;

/* Gramaticas para control de flujo*/
control_flujo:
	sentencia_while
	|sentencia_dowhile PUNTO_Y_COMA
	|condicional
	;

sentencia_dowhile:
	|	DO bloque WHILE PAR_ABIERTO condicion PAR_CERRADO
	;

sentencia_while:
		WHILE PAR_ABIERTO condicion PAR_CERRADO DO bloque
	;

condicion:	condicion COMPARATIVOS factor
	|	factor COMPARATIVOS factor			{
								ptr_exp exp1 = $1;
								ptr_exp exp2 = $3;
								//printf("\n\n\n Condicion algo\n %f  .... %f\n",exp1->flotante, exp2->flotante );

								}
	|	BOOL
	;

condicional:   	mif
	|	vif
	;

mif:		IF PAR_ABIERTO condicion PAR_CERRADO THEN mif ELSE mif
	|	bloque
	;
vif:		IF PAR_ABIERTO condicion PAR_CERRADO THEN bloque
	|	IF PAR_ABIERTO condicion PAR_CERRADO THEN mif ELSE vif

	;

/*    ------------------       */

tipoDeDato:	
	TD_INT		{$$=1;}
	|TD_FLOAT	{$$=2;}
	|TD_CHAR	{$$=3;}
	|TD_STRING	{$$=4;}
	|TD_BOOL	{$$=5;}
	;

%%

int main(int argc, char *argv[])
{ 
	yyin=fopen(argv[1],"r");
	archSal=fopen("GeneracionCdigo.txt","w");
	inicializarTabla();
    	yyparse();  //llamada al analizador sintáctico

	imprimirTablaSimbolos(tablaSimbolos);
	fclose(yyin);
	fclose(archSal);

}

void inicializarTabla(){
	tablaSimbolos = (tab*)malloc(sizeof(tab));
	tablaSimbolos->inicio= NULL;
	tablaSimbolos->fin=NULL;

}

ptr_exp inicializarExpresion(){
	ptr_exp expresion;
	expresion = (exp*)malloc(sizeof(exp));
	return expresion;
}

void yyerror(const char* detail){
    fprintf(stderr, "Error en la Linea: %d\n",linea);

    return;
}
