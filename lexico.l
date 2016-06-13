%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
/*
Integrantes:
	Jairo Proaño
	David Mejia
*/
int numeroLinea = 0;

%}
//			DEFINICION DE PATRONES
PALABRAS_RESERVADAS	(int)|(float)|(bool)|(char)|(string)|(if)|(then)|(else)|(while)|(do)|(input)|(output)|(return)
CARACTERES_ESPECIALES	(",")|(";")|(":")|("(")|(")")|("[")|("]")|("{")|("}")|("+")|("-")|("*")|("/")|("<")|(">")|("=")|("!")|("&")|("$")
OPERANDOS_COMPUESTOS	("<=")|(">=")|("==")|("!=")|("&&")|("||")
IDENTIFICADORES		[A-Za-z]+[A-Za-z0-9]*    			
INT			[0-9]+
FLOAT			[0-9]+"."[0-9]
BOOL			(true)|(false)
CHAR			\'.\'
STRING			\".+\"

//			REGLAS
%s comentarioLargo comentarioCorto
%%

"/*"                      {BEGIN(comentarioLargo);}
<comentarioLargo>[^*]*    /* Sera ignorado */ 
<comentarioLargo>"*"+[^*/]*    /* Sera ignorado */ 
<comentarioLargo>"*/"     {BEGIN(INITIAL);numeroLinea++;}

"//"                     BEGIN(comentarioCorto);

<comentarioCorto>[^\n]*  /*Sera ignorado*/; numeroLinea++;
<comentarioCorto>\n      {BEGIN(INITIAL); numeroLinea++;}


[0-9]+[a-zA-Z]+             {
printf("Error en la linea %d, token: %s\n", numeroLinea, yytext);
char texto[] = "Error: ";
 generarError(texto, numeroLinea, yytext);
escribirArchivo(texto);
}
(("#")|(".")|("|"))+[A-Za-z0-9]+           {
printf("Error en la linea: %d, token: %s\n", numeroLinea, yytext);
char texto[] = "Error: ";
 generarError(texto, numeroLinea, yytext);
escribirArchivo(texto);
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
    // ELIMINAR EL ARCHIVO DE TOKENS SI EXISTE
    status = remove("tokens.tk");

    // LECTURA DE TOKENS POR UN ARCHIVO O TECLADO
    if ( argc > 0 )
	yyin = fopen(argv[0], "r" );
    else
	yyin = stdin;
    yylex();
}
// SE AGREGAN LOS TOKENS AL FINAL DE LA LINEA      
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

void generarError(char *texto, int numeroLinea, char *valor){
    char linea[8];
    sprintf(linea, "%d", numeroLinea);
    strcat(texto, linea);
    strcat(texto, " : ");
    strcat(texto, valor);
    strcat(texto, "\n");
}
