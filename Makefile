all: 
	ocamllex miniclexer.mll
	menhir -v minicparser.mly
	ocamlc minic.ml minictyp.ml minicparser.mli minicparser.ml miniclexer.ml minicc.ml

test:	all
	./a.out example.minic
	./a.out example2.minic
	./a.out example3.minic

fail : all
	#./a.out example_fail.minic
	./a.out example_fail2.minic

clean:
	rm miniclexer.ml minicparser.ml *.mli *.automaton *.conflicts *.cmi *.cmo a.out -f 
