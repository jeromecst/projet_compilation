all:
	ocamllex analyseur_lexical.mll 
	ocaml analyseur_lexical.ml < example.minic
	menhir -v analyseur_syntaxique.mly

clean:
	rm *.ml *.mli *.automaton *.conflicts *.cmi *.cmo -f
