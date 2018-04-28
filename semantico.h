
//////////Head File//////////
#include <stdbool.h>

//////////Variables/////////



//////////Estructuras/////////
typedef struct nodo{
	char* nombre;
	int tipoDato;
	union{
		char* cadena;
		int entero;
		float flotante;
		char caracter;
		bool boolean;
	}valor;
	struct nodo *siguiente;

}sym, *ptr_sym;

typedef struct tabla{
	ptr_sym inicio;
	ptr_sym fin;

}tab, *ptr_tab;

typedef struct expresion{
	int tipoDato;
	int entero;
	float flotante;
	bool boolean;
	char caracter;
	char* string;
}exp, *ptr_exp;


//////////Funciones/////////
bool getSimbolo(ptr_tab, char*);
ptr_sym getNodoSimbolo(ptr_tab, char*);
void insertarSimbolos(ptr_tab, ptr_sym);
void imprimirTablaSimbolos(ptr_tab);
void cambiarValor(ptr_tab, char*, int, ptr_exp);




