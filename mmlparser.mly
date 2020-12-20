%{
  open Mml
%}

%token INT
%token VOID
%token BOOL
%token EQUAL
%token WHILE
%token <int> CST 
%token ADD
%token COMMA
%token RETURN
%token MUL
%token LESSTHAN
%token LBRACKET
%token RBRACKET
%token LPAR
%token RPAR
%token IF
%token ELSE
%token <string> IDENT 
%token SEMI
%token PUTCHAR

%left MUL
%left ADD 
%left LESSTHAN

%start prog
%type <Mml.expr> prog

%%

prog: 
       a=list(variable) b=list(fun_def) { {globals=a; functions=b} }
;

variable:
| t=typ s=IDENT EQUAL expr SEMI { (s, t) }

typ:
	| BOOL { Bool }
	| INT  { Int }
	| VOID { Void }
;

fun_def:
	|  t=typ s=IDENT LPAR p=separated_list(COMMA, params ) RPAR LBRACKET l=list(variable) sq=seq RBRACKET { {name=s; params=p; return=t; locals=l; code=sq } }
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
        | LBRACKET s=seq RBRACKET    { s } ;

expr:
        | n  = CST                                          { Cst(n) }
        | e1 = expr ADD e2=expr                             { Add(e1, e2) }
        | e1 = expr MUL e2=expr                             { Mul(e1, e2) }
        | e1 = expr LESSTHAN e2=expr                        { Lt(e1, e2) }
        | s  = IDENT                                        { Get(s) }
        | s  = IDENT LPAR p=separated_list(COMMA,expr) RPAR { Call(s,p) } ;
