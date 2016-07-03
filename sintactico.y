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
%token C_MAS
%token C_MENOS
%token C_COMA
%token C_CORCHETE_A
%token C_CORCHETE_C
%token C_ASTERISCO
%token C_SLASH
%token C_MENORQUE
%token C_MAYORQUE
%token C_EXCLAMACION
%token C_Y
%token C_DOLAR
%start e
%%
e:		e linea
	|	linea
		;

linea:		condicional                   {printf("Condicional\n");}
	|	asignacion C_PUNTOYCOMA       {printf("Asignacion variable\n");}
	|	definicion C_PUNTOYCOMA       {printf("Definicion variable\n");}
	|	SALTO                         {;}
		;

asignacion:	IDENTIFICADOR C_IGUAL expr  {;}
	;

definicion:	tipo_dato C_DOSPUNTOS IDENTIFICADOR               {;}
		        ;

condicional:   	P_IF C_PARENTESIS_A condicion C_PARENTESIS_C      {;}
	;



condicion:	condicion CONECTOR dato                           {;}
	|	dato COMPARADOR dato                              {;}
	|	BOOL
	;

expr:		expr C_MAS dato               {;}
	|	expr C_MENOS dato             {;}
	|	dato                          {;}
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
