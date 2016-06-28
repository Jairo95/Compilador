#!/bin/bash
#===============================================================================
#          FILE:  makefile.sh
#         USAGE:  ./makefile.sh 
#       CREATED:  21/06/16 15:34:01 ECT
#   DESCRIPTION:  Script para generar el compilador
#===============================================================================

flex lexico.l
bison -d sintactico.y
gcc lex.yy.c sintactico.tab.c -I. -lfl

