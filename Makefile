all: 
	ocamllex miniclexer.mll
	menhir -v minicparser.mly
	ocamlc minic.ml minictyp.ml minicparser.mli minicparser.ml miniclexer.ml minicc.ml

exec:	all
	./a.out example2.minic
	./a.out example.minic

clean:
	rm miniclexer.ml minicparser.ml *.mli *.automaton *.conflicts *.cmi *.cmo a.out -f 
