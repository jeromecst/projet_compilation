%{
        open Minic

        let var_list = Hashtbl.create 0;;
        let addGloVar name exp =
                Hashtbl.add var_list name exp
        ;;

%}

%token INT VOID BOOL
%token EQUAL
%token WHILE
%token <int> CST 
%token ADD COMMA RETURN MUL
%token LESSTHAN
%token LBRACKET RBRACKET
%token LPAR RPAR
%token IF ELSE
%token <string> IDENT 
%token SEMI
%token PUTCHAR
%token FIN

%left MUL ADD LESSTHAN

%start prog
%type <Minic.prog> prog

%%
prog:
	| a = globals b = list(fun_def) FIN { {globals = a; functions = b} }
	| error
            { let pos = $startpos in
              let message = Printf.sprintf
                "échec à la position %d, %d" (pos.pos_lnum) (pos.pos_cnum - pos.pos_bol + 1)
              in
              failwith message } ;

globals:
	| g = globals v = variable { List.append g [v] }
	|                            { [] } ;


variable:
        | t=typ s=IDENT EQUAL e=expr SEMI { addGloVar s e ; (s, t) } ;

fun_def:
	|  t=typ s=IDENT LPAR p=separated_list(COMMA, params ) RPAR LBRACKET l=list(variable) sq=seq RBRACKET { {name=s; params=p; return=t; locals=l; code=sq } } ;

typ:
	| BOOL { Bool }
	| INT  { Int }
	| VOID { Void } ;

params:
        | t=typ s=IDENT { (s,t) }
;

instr:
        | PUTCHAR LPAR e=expr RPAR SEMI           { Putchar(e)}
	| s=IDENT EQUAL e=expr SEMI               { Set(s, e) }
        | i=if_statement                          { i }
        | WHILE LPAR e=expr RPAR s=then_statement { While(e, s) }
        | RETURN e=expr SEMI                      { Return(e) }
        | e=expr SEMI                             { Expr(e) }
;

if_statement:
        | IF LPAR e=expr RPAR s=then_statement                         { If(e, s, []) }
        | IF LPAR e=expr RPAR s1=then_statement ELSE s2=then_statement { If(e, s1, s2) }

seq:
        | e=list(instr) { e } ;

then_statement:
        | LBRACKET s=seq RBRACKET { s } ;

expr:
        | n  = CST                                          { Cst(n) }
        | e1 = expr ADD e2=expr                             { Add(e1, e2) }
        | e1 = expr MUL e2=expr                             { Mul(e1, e2) }
        | e1 = expr LESSTHAN e2=expr                        { Lt(e1, e2) }
        | s  = IDENT                                        { Get(s) }
        | s  = IDENT LPAR p=separated_list(COMMA,expr) RPAR { Call(s,p) } ;
