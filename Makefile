all: 
	ocamllex miniclexer.mll
	menhir -v minicparser.mly
	ocamlc minic.ml minictyp.ml minicparser.mli minicparser.ml miniclexer.ml minicc.ml

test:	all
	./a.out test/example.minic
	./a.out test/example2.minic
	./a.out test/example3.minic
	./a.out test/example4.minic

fail : all
	#./a.out test/example_fail.minic
	#./a.out test/example_fail2.minic
	#./a.out test/example_fail3.minic
	#./a.out test/example_fail4.minic
	./a.out test/example_fail5.minic

clean:
	rm miniclexer.ml minicparser.ml *.mli *.automaton *.conflicts *.cmi *.cmo a.out -f 
