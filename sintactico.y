%{
#include<stdio.h>
#include<stdlib.h>
int main(int, char **);
extern int yylex();
extern void yyerror(char *);
extern FILE *yyin;

extern int numeroLinea;
%}
%token IDENTIFICADOR
%token COMPARADOR
%token CONECTOR
%token SALTO			
%token INT
%token FLOAT
%token BOOL
%token CHAR
%token STRING

%token P_IF			
%token P_FLOAT
%token P_BOOL
%token P_CHAR
%token P_STRING
%token P_INT
%token P_THEN
%token P_ELSE
%token P_WHILE
%token P_DO
%token P_INPUT
%token P_OUTPUT
%token P_RETURN
				
%token C_DOSPUNTOS
%token C_PUNTOYCOMA
%token C_LLAVE_A
%token C_LLAVE_C
%token C_PARENTESIS_A
%token C_PARENTESIS_C
%token C_IGUAL
%token C_COMA
%token C_CORCHETE_A
%token C_CORCHETE_C
%token C_EXCLAMACION
%token C_Y
%token C_DOLAR
%left C_MAS C_MENOS
%left C_ASTERISCO C_SLASH
%start e
%%
e:
	|	comando_simple
		;
bloque:		C_LLAVE_A comando_simple C_LLAVE_C
	;
comando_simple:	comando_simple linea
	|	linea
		;

linea:		funcion                       {printf("Funcion\n");}
	|	control_flujo                 {printf("Control flujo\n");}
	|	asignacion C_PUNTOYCOMA       {printf("Asignacion variable\n");}
	|	definicion C_PUNTOYCOMA       {printf("Definicion variable\n");}
	|	retorno C_PUNTOYCOMA          {printf("Retorno\n");}
	|	salida C_PUNTOYCOMA           {printf("Salida\n");} 
	|	entrada C_PUNTOYCOMA          {printf("Entrada\n");}
	|	SALTO                         {;}
		;
control_flujo:	sentencia_while
	|	sentencia_dowhile C_PUNTOYCOMA
	|	condicional
	;

funcion:	tipo_dato C_DOSPUNTOS IDENTIFICADOR C_CORCHETE_A lista_parametros C_CORCHETE_C bloque
	;

asignacion:	IDENTIFICADOR C_IGUAL expr  {;}
	;

definicion:	tipo_dato C_DOSPUNTOS IDENTIFICADOR               {;}
		        ;

condicional:   	mif           {;}
	|	vif           {;}
	;

mif:		P_IF C_PARENTESIS_A condicion C_PARENTESIS_C P_THEN mif P_ELSE mif  {;}
	|	bloque                                                              {;}
	;
vif:		P_IF C_PARENTESIS_A condicion C_PARENTESIS_C P_THEN bloque             {;}
	|	P_IF C_PARENTESIS_A condicion C_PARENTESIS_C P_THEN mif P_ELSE vif     {;}
	;
sentencia_dowhile:
	|	P_DO bloque P_WHILE C_PARENTESIS_A condicion C_PARENTESIS_C     {;}
	;

sentencia_while:
		P_WHILE C_PARENTESIS_A condicion C_PARENTESIS_C P_DO bloque    {;}
	;

lista_parametros:
	|	lista_parametros C_COMA definicion
	|	definicion
	|	' '
	;

condicion:	condicion CONECTOR dato                           {;}
	|	dato COMPARADOR dato                              {;}
	|	BOOL
	;

expr:
	|  	C_PARENTESIS_A expr C_PARENTESIS_C                {;}
	|	expr operacion expr  {;}
	|	dato
		;

operacion:	C_MAS
	|	C_MENOS
	|	C_ASTERISCO
	|	C_SLASH
	;

dato:		IDENTIFICADOR
	|       numero
	;
numero:		INT
	|	FLOAT
	;
tipo_dato:	P_CHAR
	|	P_STRING
	|	P_BOOL
	|	P_INT
	|	P_FLOAT
	;

salida:		P_OUTPUT STRING
	;
entrada:	P_INPUT
	;
retorno:	P_RETURN dato
	;


%%
int nextToken;
    
int main(argc,argv)
int argc;
char **argv;
{
    ++argv,--argc;
    /* se salta el nombre del programa */
    int status;
    /* ELIMINAR EL ARCHIVO DE TOKENS SI EXISTE*/
    status = remove("tokens.tk");

    /* LECTURA DE TOKENS POR UN ARCHIVO O TECLADO*/
    if ( argc > 0 )
	yyin = fopen(argv[0], "r" );
    else
	yyin = stdin;
    int err = yyparse();
    nextToken = yylex();
    printf("\n");
    return 0;
}
