%{
#include<stdio.h>
#include<stdlib.h>
int main(void);
extern int yylex();
extern void yyerror(char *);
%}

%token INT
%token P_INT
%token C_DOSPUNTOS
%token C_PUNTOYCOMA
%token IDENTIFICADOR


%% 
expr: 
        P_INT C_DOSPUNTOS IDENTIFICADOR C_PUNTOYCOMA          {printf("Correcto");}
        ;
%%
int nextToken;
int main()
{
    yyparse();
    nextToken = yylex();
    return 0;
}
