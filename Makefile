all:
	ocamllex miniclexer.mll
	menhir -v minicparser.mly
	ocamlc minic.ml minicparser.mli minicparser.ml miniclexer.ml minicc.ml

clean:
	rm miniclexer.ml minicparser.ml *.mli *.automaton *.conflicts *.cmi *.cmo a.out -f 
