#!/bin/sh

if [ -z $1 ]
then
	echo "compiling..."
	ocamllex analyseur_lexical.mll 
	ocaml analyseur_lexical.ml < example.minic
	menhir -v analyseur_syntaxique.mly
	ocamlc *.ml *.mli

elif [ "$1" = "clean" ]
then
	echo "make clean..."
	rm *.ml *.mli *.automaton *.conflicts *.cmi *.cmo
fi
