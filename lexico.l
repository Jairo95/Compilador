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
int numeroLinea = 1;
void escribirArchivo(char *);
void concatenarArreglos(char *, char *);

void generarError(char *, int, char *);
%}
/*						DEFINICION DE PATRONES*/
P_INT			int
P_FLOAT			float
P_IF                    if
P_BOOL                  bool
P_CHAR                  char
P_STRING                string
P_THEN                  then
P_ELSE                  else
P_WHILE                 while
P_DO                    do
P_INPUT                 input 
P_OUTPUT                output
P_RETURN		return 	

C_PUNTOYCOMA		";"
C_DOSPUNTOS		":"
C_PARENTESIS_A          "("
C_PARENTESIS_C          ")"
C_MENOS                 "-"
C_MAS                   "+"
C_IGUAL                 "="
C_COMA                  ","
C_CORCHETE_A            "["
C_CORCHETE_C            "]"
C_LLAVE_A               "{"
C_LLAVE_C               "}"
C_ASTERISCO             "*"
C_SLASH                 "/"
C_EXCLAMACION		"!"	
C_Y                     "&"
C_DOLAR			"$"						

COMPARADOR	        ("<=")|(">=")|("==")|("!=")|("<")|(">")
CONECTOR                ("&&")|("||")
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

\n  { numeroLinea++; return SALTO;}
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

{P_FLOAT}   {
char texto[] = "P_FLOAT: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_FLOAT;
}


{P_IF}   {
char texto[] = "P_IF: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_IF;
}


{P_BOOL}   {
char texto[] = "P_BOOL: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_BOOL;
}


{P_CHAR}   {
char texto[] = "P_CHAR: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_CHAR;
}


{P_STRING}   {
char texto[] = "P_STRING: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_STRING;
}


{P_THEN}   {
char texto[] = "P_THEN: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_THEN;
}


{P_ELSE}   {
char texto[] = "P_ELSE: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_ELSE;
}


{P_WHILE}   {
char texto[] = "P_WHILE: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_WHILE;
}


{P_DO}   {
char texto[] = "P_DO: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_DO;
}


{P_INPUT}   {
char texto[] = "P_INPUT: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_INPUT;
}


{P_OUTPUT}   {
char texto[] = "P_OUTPUT: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_OUTPUT;
}


{P_RETURN}   {
char texto[] = "P_RETURN: ";
concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return P_RETURN;
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

{C_PARENTESIS_A}   {
char texto[] = "C_PARENTESIS_A: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_PARENTESIS_A;
}
{C_PARENTESIS_C}   {
char texto[] = "C_PARENTESIS_C: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_PARENTESIS_C;
}
{C_MENOS}   {
char texto[] = "C_MENOS: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_MENOS;
}	     
{C_MAS}   {
char texto[] = "C_MAS: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_MAS;
}

{C_IGUAL}   {
char texto[] = "C_IGUAL: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_IGUAL;
}

{C_COMA}   {
char texto[] = "C_COMA: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_COMA;
}

{C_CORCHETE_A}   {
char texto[] = "C_CORCHETE_A: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_CORCHETE_A;
}

{C_CORCHETE_C}   {
char texto[] = "C_CORCHETE_C: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_CORCHETE_C;
}

{C_LLAVE_A}   {
char texto[] = "C_LLAVE_A: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_LLAVE_A;
}

{C_LLAVE_C}   {
char texto[] = "C_LLAVE_C: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_LLAVE_C;
}

{C_SLASH}   {
char texto[] = "C_SLASH: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_SLASH;
}

{C_ASTERISCO}   {
char texto[] = "C_ASTERISCO: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_ASTERISCO;
}

{C_EXCLAMACION}   {
char texto[] = "C_EXCLAMACION: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_EXCLAMACION;
}

{C_Y}   {
char texto[] = "C_Y: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_Y;
}

{C_DOLAR}   {
char texto[] = "C_DOLAR: ";
 concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return C_DOLAR;
}
		
{COMPARADOR}    {
char texto[] = "COMPARADOR: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return COMPARADOR;
}

{CONECTOR}    {
char texto[] = "CONECTOR: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return CONECTOR;
}
{INT}                     {
char texto[] = "ENTERO: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return INT;
}
{FLOAT}                   {
char texto[] = "FLOTANTE:";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return FLOAT;
}
{BOOL}                    {
char texto[] = "BOOLEAN: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
 return BOOL;
}
{CHAR}            {
char texto[] = "CARACTER: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
return CHAR;
}
{STRING}                  {
char texto[] = "STRING: ";
    concatenarArreglos(texto, yytext);
escribirArchivo(texto);
 return STRING;
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
    fprintf(stderr, "%s linea: %d \n", s, numeroLinea); 
} 
