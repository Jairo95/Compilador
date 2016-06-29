%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sintactico.tab.h>
/*
Integrantes:
	Jairo Proaño
	David Mejia
*/
void yyeror(char *);
int numeroLinea = 0;
void escribirArchivo(char *);
void concatenarArreglos(char *, char *);

void generarError(char *, int, char *);
%}
/*						DEFINICION DE PATRONES*/
P_INT			int
PALABRAS_RESERVADAS	(float)|(bool)|(char)|(string)|(if)|(then)|(else)|(while)|(do)|(input)|(output)|(return)

C_PUNTOYCOMA		";"
C_DOSPUNTOS		":"
CARACTERES_ESPECIALES	(",")|("(")|(")")|("[")|("]")|("{")|("}")|("+")|("-")|("*")|("/")|("<")|(">")|("=")|("!")|("&")|("$")
OPERANDOS_COMPUESTOS	("<=")|(">=")|("==")|("!=")|("&&")|("||")
IDENTIFICADORES		[A-Za-z]+[A-Za-z0-9]*    			
INT			[0-9]+
FLOAT			[0-9]+"."[0-9]
BOOL			(true)|(false)
CHAR			\'.\'
STRING			\".+\"

/*						REGLAS*/
%s comentarioLargo comentarioCorto
%%
"//"                     BEGIN(comentarioCorto);
<comentarioCorto>[^\n]*  /*Sera ignorado*/;
<comentarioCorto>\n      {BEGIN(INITIAL); numeroLinea++;}

\n  { numeroLinea++;
     return SALTO;}
"/*"                      {BEGIN(comentarioLargo);}
<comentarioLargo>[^*\n]*    /* Sera ignorado */ 
<comentarioLargo>"*"+[^*/\n]*    /* Sera ignorado */
<comentarioLargo>"*/"   {BEGIN(INITIAL);}

[0-9]+[a-zA-Z0-9]+             {
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

{P_INT}    {
char texto[] = "P_INT: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_INT;
}

{PALABRAS_RESERVADAS}    {
char texto[] = "PALABRA_RESERVADA: ";
concatenarArreglos(texto, yytext);  
escribirArchivo(texto);

}


{C_PUNTOYCOMA}   {
char texto[] = "C_PUNTOYCOMA: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_PUNTOYCOMA;
}
{C_DOSPUNTOS}   {
char texto[] = "C_DOSPUNTOS: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_DOSPUNTOS;
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
return IDENTIFICADOR;
}


%%


/* SE AGREGAN LOS TOKENS AL FINAL DE LA LINEA      */
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

void yyerror(char *s) { 
    fprintf(stderr, "%s\n", s); 
} 
