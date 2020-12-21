%{
  open Mml
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
%type <Mml.prog> prog

%%
(*


prog:
          |glb = globals fcts = functions MAIN ACCO_O p=seq ACCO_F EOF { {globals = glb; functions = fcts} }
          ;
          functions:
                    |f = list(fun_def) {f}
                    ;
                    globals:
                              | g1 = globals g2 = global {  addVarGl(id,t,0); List.append g1 [g2] }
                                | {[]}
                                ;
                                fun_def:
                                         |ret = typ id = IDENT PAR_O param = list(param) PAR_F ACCO_O loc = locals s = seq ACCO_F 
                                             { let fct = {name = id; params = param; return = ret; locals = loc; code = s} in fct}
                                             et ça ne pose pas de probleme

*)

prog: 
        | t=typ s=INDENT typid_next { {globals=[]; functions=b } }
        | error
            { let pos = $startpos in
              let message = Printf.sprintf
                "échec à la position %d, %d" (pos.pos_cnum - pos.pos_bol + 1) (pos.pos_lnum)
              in
              failwith message }
;

typid_next:
        | EQUAL expr {}
	| LPAR p=separated_list(COMMA, params ) RPAR LBRACKET l=list(variable) sq=seq RBRACKET { {name=s; params=p; return=t; locals=l; code=sq } }
;

variable:
        | t=typ s=IDENT EQUAL expr { (s, t) }
        ;

fun_def:
	|  t=typ s=IDENT LPAR p=separated_list(COMMA, params ) RPAR LBRACKET l=list(variable) sq=seq RBRACKET { {name=s; params=p; return=t; locals=l; code=sq } }
;

typ:
	| BOOL { Bool }
	| INT  { Int }
	| VOID { Void }
;


params:
        | t=typ s=IDENT { (s,t) }
;

instr:
        | PUTCHAR e=expr SEMI                     { Putchar(e)}
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
