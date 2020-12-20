all:
	ocamllex mmllexer.mll
	menhir -v mmlparser.mly
	ocamlc mml.ml mmlparser.mli mmlparser.ml mmllexer.ml mmlc.ml

clean:
	rm mmllexer.ml mmlparser.ml *.mli *.automaton *.conflicts *.cmi *.cmo a.out -f 
