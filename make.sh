#!/bin/sh

if [ -z $1 ]
then
	echo "compiling..."
	ocamllex analyseur_lexical.mll 
	ocaml analyseur_lexical.ml < example.minic
	menhir analyseur_lexical.mly
elif [ "$1" = "clean" ]
then
	echo "make clean..."
	rm *.ml *.mli *.automaton *.conflicts
fi

