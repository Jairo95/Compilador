
//////////Head File//////////
#include "semantico.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *archSal1;//imprime tabla de símbolos

//////////Funciones//////////

ptr_sym getNodoSimbolo(ptr_tab tablaSimbolos, char* nombre){
	ptr_sym simbolo;
	if(tablaSimbolos->inicio != NULL){
		for (simbolo = tablaSimbolos->inicio; NULL != simbolo; simbolo =  simbolo->siguiente){
			if(strcmp(simbolo->nombre, nombre) == 0){
				return simbolo;
			}
		}
	}
	return NULL;
}

bool getSimbolo(ptr_tab tablaSimbolos, char* nombre){
	ptr_sym simbolo;
	if(tablaSimbolos->inicio != NULL){
		for (simbolo = tablaSimbolos->inicio; NULL != simbolo; simbolo =  simbolo->siguiente){
			if(strcmp(simbolo->nombre, nombre) == 0){
				return true;
			}
		}
	}
	return false;
}

void insertarSimbolos(ptr_tab tablaSimbolos, ptr_sym simbolo){
	ptr_sym nuevo;
	nuevo = simbolo;
	if(tablaSimbolos->inicio != NULL){
		tablaSimbolos->fin->siguiente = nuevo;
		tablaSimbolos->fin = nuevo;
	} else {
		tablaSimbolos->fin = nuevo;
		tablaSimbolos->fin->siguiente = NULL;
		tablaSimbolos->inicio = nuevo;
		tablaSimbolos->inicio->siguiente = NULL;
		
	}
	
}

void imprimirTablaSimbolos(ptr_tab tablaSimbolos){
	ptr_sym simbolo;
	if(tablaSimbolos->inicio != NULL){
		char* tipo;
		char valor[100];
	//para imprimir tabla en consola
		printf("\n\t--TABLA DE SÍMBOLOS--");
		printf("\nTipo , Nombre , Valor\n");

	//para imprimir tabla en archivo
		archSal1=fopen("TablaSimbolos.txt","w");
		fprintf(archSal1,"\t--TABLA DE SÍMBOLOS--\n");
		fprintf(archSal1,"    Tipo |\t    Nombre  |\t    Valor\n");
		for (simbolo = tablaSimbolos->inicio; NULL != simbolo; simbolo =  simbolo->siguiente){
			switch (simbolo->tipoDato){
			case 1:
				tipo = "int";
				sprintf(valor, "%d", simbolo->valor.entero);
				break;
			case 2:
				tipo = "float";
				sprintf(valor, "%f", simbolo->valor.flotante);
				break;
			case 3:
				tipo = "char";
				sprintf(valor, "%c", simbolo->valor.caracter);
				break;
			case 4:
				tipo = "string";
				sprintf(valor, "%s", simbolo->valor.cadena);
				break;
			case 5:
				tipo = "bool";
				break;
			}

			printf("%s , %s , %s\n", tipo, simbolo->nombre, valor);
			fprintf(archSal1,"    %s   |\t %s    |\t    %s\n", tipo, simbolo->nombre, valor);
		}
		fclose(archSal1);
	}
	


}

void cambiarValor(ptr_tab tablaSimbolos, char* nombre, int tipoDato, ptr_exp expresion){
	ptr_sym simbolo;
	if(tablaSimbolos->inicio != NULL){
		for (simbolo = tablaSimbolos->inicio; NULL != simbolo; simbolo =  simbolo->siguiente){
			if(strcmp(simbolo->nombre, nombre) == 0){
				switch(tipoDato){
				case 1:
					simbolo->valor.entero = expresion->entero;
					break;
				case 2:
					simbolo->valor.flotante = expresion->flotante;
					break;
				case 3:
					simbolo->valor.caracter = expresion->caracter;
					break;
				case 4:
					simbolo->valor.cadena = expresion->string;
					break;
				case 5:
					simbolo->valor.boolean = expresion->boolean;
					break;
				}
			}
		}
	}
}

