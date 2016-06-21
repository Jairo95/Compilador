#!/bin/bash
#===============================================================================
#          FILE:  makefile.sh
#         USAGE:  ./makefile.sh 
#       CREATED:  21/06/16 15:34:01 ECT
#   DESCRIPTION:  Script para generar el compilador
#===============================================================================

flex lexico.l
gcc lex.yy.c -I. -lfl

