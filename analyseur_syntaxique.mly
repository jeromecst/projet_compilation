%{
  open Mml
%}

%token <int> CST
%token <string> IDENT
%token PLUS ETOILE MOINS
%token EGAL INEGAL INF INFEGAL ET OU
%token PAR_O PAR_F
%token FUN FLECHE
%token LET IN
%token IF THEN ELSE
%token FIN

%nonassoc IN ELSE FLECHE
%left ET OU
%left EGAL INEGAL INF INFEGAL
%left PLUS MOINS
%left ETOILE
%left PAR_O IDENT CST

%start prog
%type <Mml.expr> prog

%%

  type prog = {
    globals:   (string * typ) list;
    functions: fun_def list;
  }

fonctions

  type fun_def = {
    name:   string;
    params: (string * typ) list;
    return: typ;
    locals: (string * typ) list;
    code:   seq;
  }

types de données

  type typ =
    | Int
    | Bool
    | Void

instructions et séquences

  type instr =
    | Putchar of expr
    | Set     of string * expr
    | If      of expr * seq * seq
    | While   of expr * seq
    | Return  of expr
    | Expr    of expr
  and seq = instr list

expressions

  type expr =
    | Cst  of int
    | Add  of expr * expr
    | Mul  of expr * expr
    | Lt   of expr * expr
    | Get  of string
    | Call of string * expr list




%inline binop:
| PLUS    { Add }
| MOINS   { Sub }
| ETOILE  { Mul }
| EGAL    { Eq }
| INEGAL  { Neq }
| INF     { Lt }
| INFEGAL { Le }
| ET      { And }
| OU      { Or }
;

