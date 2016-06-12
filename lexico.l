%{
#include<stdio.h>
//#include<tokens.h>
#include<stdlib.h>
#include<string.h>

int numeroLinea = 0;

%}

PALABRAS_RESERVADAS	(int)|(float)|(bool)|(char)|(string)|(if)|(then)|(else)|(while)|(do)|(input)|(output)|(return)
CARACTERES_ESPECIALES	(",")|(";")|(":")|("(")|(")")|("[")|("]")|("{")|("}")|("+")|("-")|("*")|("/")|("<")|(">")|("=")|("!")|("&")|("$")
OPERANDOS_COMPUESTOS	("<=")|(">=")|("==")|("!=")|("&&")|("||")
IDENTIFICADORES		[A-Za-z]+[A-Za-z0-9]*    			
INT			[0-9]+
FLOAT			[0-9]+"."[0-9]
BOOL			(true)|(false)
CHAR			\'.\'
STRING			\".+\"

%s comentarioLargo comentarioCorto


%%
"/*"                      {BEGIN(comentarioLargo);numeroLinea++;}
<comentarioLargo>[^*]*    /* Sera ignorado */ 
<comentarioLargo>"*"+[^*/]*    /* Sera ignorado */ 
<comentarioLargo>"*/"     {BEGIN(INITIAL);numeroLinea++;}

"//"                     BEGIN(comentarioCorto);

<comentarioCorto>[^\n]*  /*Sera ignorado*/; numeroLinea++;
<comentarioCorto>\n      {BEGIN(INITIAL); numeroLinea++;}


[0-9]+[a-zA-Z]+             {
printf("Error en la linea: %d, token: %s\n", numeroLinea, yytext);
}
(("#")|(".")|("|"))+[A-Za-z0-9]+           {
printf("Error en la linea: %d, token: %s\n", numeroLinea, yytext);
}

{PALABRAS_RESERVADAS}    {
char texto[] = "PALABRA_RESERVADA: ";
concatenarArreglos(texto, yytext);  
escribirArchivo(texto);

}
{CARACTERES_ESPECIALES}   {
char texto[] = "CARACTER_ESPECIAL: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);

}

{OPERANDOS_COMPUESTOS}    {
char texto[] = "OPERANDO COMPUESTO: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);

}
{INT}                     {
char texto[] = "ENTERO: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);

}
{FLOAT}                   {
char texto[] = "FLOTANTE:";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);

}
{BOOL}                    {
char texto[] = "BOOLEAN: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
}
{CHAR}            {
char texto[] = "CARACTER: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);

}
{STRING}                  {
char texto[] = "STRING: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
}
{IDENTIFICADORES}      {
   char texto[] = "IDENTIFICADOR: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
}
\n  { numeroLinea++;}



%%

main(argc,argv)
int argc;
char **argv;
{
    ++argv,--argc;
    /* se salta el nombre del programa */
    int status;

    status = remove("tokens.tk");

    if ( argc > 0 )
	yyin = fopen(argv[0], "r" );
    else
	yyin = stdin;
    yylex();
}
      
void escribirArchivo(char *texto){
    FILE *archivoSalida;
    archivoSalida = fopen("tokens.tk", "a");
    fputs(texto, archivoSalida);
    fclose(archivoSalida);
}

void  concatenarArreglos(char *token, char *valor){
 strcat(token, valor);
 strcat(token, "\n");
}

