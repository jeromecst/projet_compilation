open Hashtbl

let var_list = Hashtbl.create 0;;

let addGloVar name exp =
        Hashtbl.add var_list name exp
;;

let main () =
        let fichier = Sys.argv.(1) in
        let c = open_in fichier in
        let lexbuf = Lexing.from_channel c in
        let prog = Minicparser.prog Miniclexer.scan_text lexbuf in
        ignore(prog);
        close_in c;
        exit 0
in

main ();
