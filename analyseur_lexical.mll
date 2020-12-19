{
        open Printf
        open Lexing

        type token =
                | EQUAL
                | WHILE
                | CST of int
                | BOOLEAN of bool
                | INT
                | VOID
                | BOOL
                | ADD
                | RETURN
                | MINUS
                | MUL
                | COMA
                | LESSTHAN
                | LBRACKET
                | RBRACKET
                | LPAR
                | RPAR
                | IF
                | ELSE
                | IDENT of string
                | SEMI
                | PUTCHAR
                | EOF

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
        | [' ' '\t']* { scan_text lexbuf }
        | "int" { INT }
        | "void" { VOID }
        | "bool" { BOOL }
        | "if" { IF }
        | "else" { ELSE }
        | '-'?digit+ as c { CST (int_of_string c) } 
        | '(' { LPAR }
        | '-' { MINUS }
        | ',' { COMA }
        | "return" { RETURN }
        | ')' { RPAR }
        | '}' { RBRACKET }
        | '{' { LBRACKET }
        | "putchar" { PUTCHAR }
        | '=' { EQUAL }
        | ("true" | "false") as c { BOOLEAN (bool_of_string c) }
        | ';' { SEMI }
        | '+'  { ADD } 
        | '*'  { MUL } 
        | '<'  { LESSTHAN } 
        | ident as c { IDENT (c) }
        | '\n' { Lexing.new_line lexbuf; scan_text lexbuf }
        | _ as c { 
                let (x, y) = get_lexbuf_position lexbuf in
                failwith (sprintf "Unknown char : '%c', ligne %d, caractère %d" c y x ) }
        | eof { EOF }


{
        let rec token_to_string = function
                | SEMI -> sprintf "SEMI"
                | PUTCHAR -> sprintf "PUTCHAR"
                | EQUAL -> sprintf "EQUAL"
                | COMA -> sprintf "COMA"
                | WHILE -> sprintf "WHILE"
                | ADD -> sprintf "PLUS"
                | RETURN -> sprintf "RETURN"
                | MINUS -> sprintf "MINUS"
                | BOOLEAN c -> sprintf "BOOLEAN %b" c
                | CST c -> sprintf "CST %d" c
                | MUL -> sprintf "MUL"
                | BOOL-> sprintf "BOOL"
                | INT -> sprintf "INT"
                | VOID -> sprintf "VOID"
                | IF -> sprintf "IF"
                | ELSE -> sprintf "ELSE"
                | IDENT c -> sprintf "IDENT %s" c
                | LESSTHAN -> sprintf "LESSTHAN"
                | LPAR -> sprintf "LPAR"
                | RPAR -> sprintf "RPAR"
                | LBRACKET -> sprintf "LBRACKET"
                | RBRACKET -> sprintf "RBRACKET"
                | EOF -> ( sprintf "EOF" ;  exit 0 )

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
