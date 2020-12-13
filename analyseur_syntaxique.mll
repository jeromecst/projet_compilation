(*
 Jérôme Coquisart
 utilisation : ocamllex exercice4.mll; ocaml exerice4.ml < textEx4
 résultat : dans la console
 *)

{
        open Printf
        open Lexing

        type token =
                | TYPE of string
                | EQUAL
                | WHILE
                | INT of int
                | BOOL of bool
                | PLUS
                | MUL
                | FUN
                | LESSTHAN
                | LBRACKET
                | RBRACKET
                | LPAR
                | RPAR
                | IF
                | IDENT of string
                | SEMI

        exception Eof

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
let spaces = ' '*


rule scan_text = parse
        | [' ' '\t']* { scan_text lexbuf }
        | ("int" |  "void" | "bool" ) as s { TYPE (s) }
        | "if" { IF }
        | '-'?digit+ as c { INT (int_of_string c) } 
        | ident as c { IDENT (c) }
        | '(' { LPAR }
        | ')' { RPAR }
        | '}' { RBRACKET }
        | '{' { LBRACKET }
        | '=' { EQUAL }
        | ("true" | "false") as c { BOOL (bool_of_string c) }
        | ';' { SEMI }
        | '+'  { PLUS } 
        | '*'  { MUL } 
        | '<'  { LESSTHAN } 
        | '\n' { Lexing.new_line lexbuf; scan_text lexbuf }
        | _ as c { 
                let (x, y) = get_lexbuf_position lexbuf in
                failwith (sprintf "Caractère non reconnu : '%c', ligne %d, caractère %d" c y x ) }
        | eof { raise Eof }

(* rule read_ident vartype varname = parse *)
        

{
        let rec token_to_string = function
                | SEMI -> sprintf "SEMI"
                | EQUAL -> sprintf "EQUAL"
                | WHILE -> sprintf "WHILE"
                | PLUS -> sprintf "PLUS"
                | BOOL c -> sprintf "BOOL %b" c
                | INT c -> sprintf "INT %d" c
                | MUL -> sprintf "MUL"
                | TYPE s -> sprintf "TYPE %s" s
                | FUN -> sprintf "FUN"
                | IF -> sprintf "IF"
                | IDENT c -> sprintf "IDENT %s" c
                | LESSTHAN -> sprintf "LESSTHAN"
                | LPAR -> sprintf "LPAR"
                | RPAR -> sprintf "RPAR"
                | LBRACKET -> sprintf "LBRACKET"
                | RBRACKET -> sprintf "RBRACKET"

        let main () =
                let cin =
                        if Array.length Sys.argv > 1
                        then open_in Sys.argv.(1)
                        else stdin
                in

                let lexbuf = from_channel cin in
                let rec boucle () =
                        let tok = scan_text lexbuf in
                        printf "%s\n" (token_to_string tok);
                        boucle ()
                in
                boucle () 

        let _ = main ();
}
