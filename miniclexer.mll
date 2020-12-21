{
open Printf
open Lexing
open Minicparser

let get_lexbuf_position lexbuf = 
        let p = Lexing.lexeme_start_p lexbuf in
        let x = p.pos_cnum in
        let y = p.pos_lnum in
        let z = p.pos_bol in
        ((x-z + 1), y)
}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let ident = alpha (digit | alpha | '_')*
let symboles = ( "->" | '+' | '(' | ')' | '=' | '|' )

rule scan_text = parse
        | [' ' '\t']*           { scan_text lexbuf }
        | '\n'                  { Lexing.new_line lexbuf; scan_text lexbuf }
        | "//"[^'\n']*          { scan_text lexbuf }
        | "int"                 { INT }
        | "void"                { VOID }
        | "bool"                { BOOL }
        | "true" | "false" as c { BOOLEAN (bool_of_string c) }
        | "while"               { WHILE }
        | "if"                  { IF }
        | "else"                { ELSE }
        | '-'?digit+ as c       { CST (int_of_string c) }
        | '('                   { LPAR }
        | ','                   { COMMA }
        | "return"              { RETURN }
        | ')'                   { RPAR }
        | '}'                   { RBRACKET }
        | '{'                   { LBRACKET }
        | "putchar"             { PUTCHAR }
        | '='                   { EQUAL }
        | ';'                   { SEMI }
        | '+'                   { ADD }
        | '*'                   { MUL }
        | '<'                   { LESSTHAN }
        | ident as c            { IDENT (c) }
        | _ as c                {
                let (x, y) = get_lexbuf_position lexbuf in
                failwith (sprintf "Unknown char : '%c', ligne %d, caractère %d" c y x ) }
        | eof                   { FIN }
