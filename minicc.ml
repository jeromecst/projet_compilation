open Minic

(*
 * Ajoute les variables globales dans une table de hachage
 *)
let addVar vars =
        let rec addVar vars env = 
                match vars with 
                | [] -> env
                | hd::tl ->     let (s, t, _) = hd in 
                                Hashtbl.add env s t;
                                addVar tl env
        in
        let env = Hashtbl.create 20 in
        addVar vars env ;;


(*
 * Ajoute chaque fonction dans une table de hachage
 *)
let addFun funs =
        let rec addFun funs env = 
                match funs with 
                | [] -> env
                | hd::tl ->     let s = hd.name in
                                if Hashtbl.mem env s 
                                then failwith "erreur, 2 fonctions on le même nom" 
                                else
                                Hashtbl.add env s hd;
                                addFun tl env
        in
        let env = Hashtbl.create 20 in
        addFun funs env ;;

(*
 * Ajoute les paramètres d'une fonction comme variables locales
 *)
let rec addParams table p =
        match p with
        | [] -> ()
        | hd::tl ->
                        let (s, t) = hd in
                        Hashtbl.add table s t;
                        addParams table tl

(*
* Ajoute les variables locales d'une fonction dans une nouvelle table de hachage
*)
let addLocVar funs = 
        let rec addLocVar funs env = 
                match funs with 
                | [] -> env
                | hd::tl ->     let s = hd.name in
                                let l = hd.locals in
                                let p = hd.params in
                                let envloc = addVar l in
                                addParams envloc p;
                                Hashtbl.add env s envloc;
                                addLocVar tl env
        in
        let env = Hashtbl.create 20 in
        addLocVar funs env ;;


let main () =
        let fichier = Sys.argv.(1) in
        let c = open_in fichier in
        let lexbuf = Lexing.from_channel c in
        let prog = Minicparser.prog Miniclexer.scan_text lexbuf in

        let env_var = addVar prog.globals in
        let env_fun = addFun prog.functions in
        let env_loc = addLocVar prog.functions in
        let _ = Minictyp.type_prog prog (env_var, env_fun, env_loc) in

        ignore(prog);
        close_in c;
        exit 0
;;

main ();
