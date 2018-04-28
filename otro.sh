#!/bin/bash
#===============================================================================
#          FILE:  otro.sh
#         USAGE:  ./otro.sh 
#        AUTHOR:  Jairo Proaño (), jairotft@gmail.com
#       CREATED:  30/08/16 02:22:55 ECT
#   DESCRIPTION:  
#===============================================================================

bison -d -v sintactico.y 
flex lexico.l 
gcc -Wall -O -o analizador lex.yy.c sintactico.tab.c semantico.c -lfl -lm

