%{
#include<stdio.h>
#include<stdlib.h>

FILE *archivoSalida;
int main(int, char **);
extern int yylex();
extern void yyerror(char *);
extern FILE *yyin;

extern int numeroLinea;
%}

%union{
    char *tipoDato;
    char *identificador;
    double dValor;
    int iValor;
    char cValor;
    char *sValor;
}

%token COMPARADOR
%token CONECTOR
%token SALTO			
%token	<iValor> INT
%token	<dValor> FLOAT
%token	<sValor> BOOL
%token	<cValor> CHAR 
%token	<sValor> STRING

%token P_IF			
%token	<tipoDato> P_FLOAT
%token	<tipoDato> P_BOOL
%token	<tipoDato> P_CHAR
%token	<tipoDato> P_STRING
%token	<tipoDato> P_INT
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
			
%type	<tipoDato> tipo_dato
%token	<identificador>	IDENTIFICADOR
			
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

linea:		funcion                       {

 }
	|	control_flujo                 {
		}
	    |	asignacion C_PUNTOYCOMA       {

     }
|	definicion C_PUNTOYCOMA       {

     }
	|	retorno C_PUNTOYCOMA          {
     }
	 |	salida C_PUNTOYCOMA           {
	 } 
	     |	entrada C_PUNTOYCOMA          {
}
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

definicion:	tipo_dato C_DOSPUNTOS IDENTIFICADOR    {printf("Definicion Sintactico: %s\n", $1);
		    ;}
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
tipo_dato:	P_CHAR         {$$ = $1;}
	|	P_STRING        {$$ = $1;}
	|	P_BOOL        {$$ = $1;}
	|	P_INT        {$$ = $1;}
	|	P_FLOAT        {$$ = $1;}
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

    int status;
     
     status = remove("tabla.tk");
    archivoSalida = fopen("tabla.tk", "a");
    
    
    ++argv,--argc;
    /* se salta el nombre del programa */
    
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
    fclose(archivoSalida);
    return 0;
}


void insertarTablaSimbolos(char *tipoDato, char *identificador, char *dato) {

}
