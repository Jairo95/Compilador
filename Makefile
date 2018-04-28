analizador: semantico.o  sintactico.tab.o lex.yy.o
	gcc -g -o analizador semantico.o sintactico.tab.o lex.yy.o -lm -lfl -L.

semactico.o: semantico.c semanctico.h
	gcc -g -c semantico.c -I.

sintactico.tab.o: sintactico.tab.c semantico.h
	gcc -g -c sintactico.tab.c -I.

lex.yy.o: lex.yy.c semantico.h
	gcc -g -c lex.yy.c -I.

sintactico.tab.c sintactico.tab.h: sintactico.y
	bison -d -t -v sintactico.y


lex.yy.c: lexico.l sintactico.tab.h
	flex lexico.l


clean:
	rm *.o
