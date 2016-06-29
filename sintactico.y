%{
#include<stdio.h>
#include<stdlib.h>
int main(int, char **);
extern int yylex();
extern void yyerror(char *);
extern FILE *yyin;
%}

%token SALTO
%token INT
%token P_INT
%token C_DOSPUNTOS
%token C_PUNTOYCOMA
%token IDENTIFICADOR


%% 
expr:
	|	expr sentencia
		;
sentencia:	SALTO
	|	P_INT C_DOSPUNTOS IDENTIFICADOR C_PUNTOYCOMA SALTO          {printf("Definicion variable\n");}
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
