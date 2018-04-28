/***
ESCUELA POLITÉCNICA NACIONAL
INGENIERÍA DE SISTEMAS
COMPILADORES 
PROYECTO PRIMER BIMESTRE - ETAPA 2: ANALIZADOR LÉXICO PARA EL ANALIZADOR SINTÁCTICO
ANALIZADOR LÉXICO
	Johanna Arias
	Samantha De la Cruz
FECHA: a 2016/06/30
GR_02
***/

	/*** Sección de declaraciones ***/
%{
	#include <stdlib.h> 
	#include <semantico.h>
	#include "sintactico.tab.h"

	int linea=1;//contador de línea
	ptr_sym nuevoSimbolo(void);

	
%}

/* Ordena a Flex que genere un analizador que mantenga el número de la línea actual*/
%option yylineno 

espacio	" "|\t
digito	[0-9]
letra	[a-z|A-Z]
string	\"[^\n"]+\"

caracteres_especiales 		"!"|"&"|"$"
comparativos 			">"|"<"|">="|"<="|"=="|"!="|"&&"|"||"
bool 				"True"|"False"|"true"|"false"|"TRUE"|"FALSE"
comen_simple 			"//".*?
comen_compuesto 		"/*"[^"*/"]*



%%

{espacio}+			;//no hace nada
"#include" 			return INCLUDE;
"<"[a-z]+".h>" 			return LIBRERIA;
"if"      			return IF;
"for"      			return FOR;
"else"     			return ELSE;
"return"  			return RETURN;
"int"				{return TD_INT;}
"float"				{return TD_FLOAT;}
"char"				{return TD_CHAR;}
"string"			{return TD_STRING;}
"bool"				{return TD_BOOL;}
"void"    			return VOID;
"then"    			return THEN;
"while"   			return WHILE;
"do"      			return DO;
"input"   			return INPUT;
"output"  			return OUTPUT;
{bool} 				{return BOOL;}
[A-Za-z]+[A-Za-z0-9]* 		{yylval.symptr = nuevoSimbolo();	return IDENTIFICADOR;}
({digito}+|"+"{digito}+) 	{yylval.ival = atoi(yytext);		return ENTEROPOSITIVO;}
"-"{digito}+			{yylval.ival = atoi(yytext);		return ENTERONEGATIVO;}
{digito}*"."{digito}+		{yylval.dval = atof(yytext);		return FLOAT;}
{caracteres_especiales}		return CARACTER_ESPECIAL;
{comparativos} 			return COMPARATIVOS;			
"'"{letra}"'"			{yylval.cval = yytext[1];		return CHAR;}
{string} 			{yylval.sval = strdup(yytext); 		return STRING;}
"+"				return MAS;
"-"				return MENOS;
"*"				return MULTIPLICACION;
"/"				return DIVISION;
"="				{return IGUAL;}
":"				{return DOS_PUNTOS;}
","				return COMA;
";"				{return PUNTO_Y_COMA;}
"{"				return LLAV_ABIERTA;
"}"				return LLAV_CERRADA;
"("				return PAR_ABIERTO;
")"				return PAR_CERRADO;
"["				{return COR_ABIERTO;}
"]"				{return COR_CERRADO;}
\n				{linea++;}
.				{;} /* Ignora todos los demás caracteres e imprime la línea de error */
				
%%
/*
	int yywrap(void){
		return 1;
}
*/

ptr_sym nuevoSimbolo(){
	ptr_sym simbolo;

	//Asigna espacio para el simbolo
	simbolo = (sym*)malloc(sizeof(sym));
	//Se le asigna un nombre al simbolo
	simbolo->nombre = strdup(yytext);
	
	simbolo->siguiente = NULL;
	return simbolo;
}


