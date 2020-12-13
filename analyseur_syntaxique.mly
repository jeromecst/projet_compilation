%{
  open Mml
%}

%token INT
%token VOID
%token BOOL
%token EQUAL
%token WHILE
%token <int> CST 
%token <bool> BOOLEAN
%token ADD
%token COMA
%token RETURN
%token MINUS
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
%token EOF

%left MUL
%left ADD 
%nonassoc MINUS
%left LESSTHAN

%start prog
%type <Mml.expr> prog

%%

prog:
        | instr prog     {}
        | fun_def prog   {}
        | EOF {}
;

typ:
	| BOOL {}
	| INT  {}
	| VOID {}
;

fun_def:
	| typ IDENT params LBRACKET list(instr) RBRACKET {}
;

params:
	| LPAR param RPAR {}
;

param:
	| (* empty *) {}
	| n_empty_param {}
;

n_empty_param:
	| typ IDENT COMA n_empty_param {}
	| typ IDENT {}
;
	

instr:
        | PUTCHAR params SEMI {}
	| typ IDENT EQUAL expr SEMI {}
	| IDENT EQUAL expr SEMI     {}
        | if_statement {}
        | while_statement {}
        | RETURN expr SEMI {}
        | fun_call {}
;

fun_call:
        | IDENT params {} ;

seq:
        | list(instr) {} ;

if_statement:
        | IF LPAR expr RPAR then_statement {}
        | IF LPAR expr RPAR then_statement ELSE then_statement {}
;

while_statement:
        | WHILE LPAR expr RPAR then_statement {}
;

then_statement:
        | LBRACKET seq RBRACKET {}
;

expr:
        | CST {}
        | BOOLEAN {}
        | expr ADD expr {}
        | expr MUL expr {}
        | expr MINUS expr {}
        | expr LESSTHAN expr {}
        | IDENT {}
        | fun_call {}
;
