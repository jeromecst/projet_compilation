#!/bin/sh

if [ -z $1 ]
then
	echo "compiling..."
	ocamllex analyseur_syntaxique.mll && ocaml analyseur_syntaxique.ml < example.minic
elif [ "$1" = "clean" ]
then
	echo "removing analyseur_syntaxique.ml"
	rm analyseur_syntaxique.ml
fi

