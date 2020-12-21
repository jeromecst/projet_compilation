open Hashtbl

let main () =
        let fichier = Sys.argv.(1) in
        let c = open_in fichier in
        let lexbuf = Lexing.from_channel c in
        let prog = Minicparser.prog Miniclexer.scan_text lexbuf in
        ignore(prog);
        close_in c;
        exit 0
;;

main ();
