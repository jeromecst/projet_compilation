(*Analyseur de typage PROJET *)
open Minic

let search_tables envs x =
        let (env1, env2, env3, currentFunction) = envs in
        try
                if Hashtbl.mem env3 currentFunction then (let env' = Hashtbl.find env3 currentFunction in Hashtbl.find env' x ) else Hashtbl.find env1 x
        with e ->
                Printf.printf "undeclared variable %s: \n" x ;
                raise e


let rec type_expr e envs =
        match e with 
        | Cst _ -> Int
        | Add(e1,e2)->
                        let t1 = type_expr e1 envs in
                        let t2 = type_expr e2 envs in
                        if t1 = Int && t2 = Int 
                                then Int
                                else failwith "type error"
        |Mul(e1,e2)->
                        let t1 = type_expr e1 envs in
                        let t2 = type_expr e2 envs in
                        if t1 = Int && t2 = Int 
                                then Int
                                else failwith "type error"
        |Lt(e1,e2)->
                        let t1 = type_expr e1 envs in
                        let t2 = type_expr e2 envs in
                        if t1 = Int && t2 = Int 
                                then Int
                                else failwith "type error"
        | Get(x)->  
                        search_tables envs x

        | Call(f,b)-> 
                        let (_, env2, _, _) = envs in
                        let func = Hashtbl.find env2 f in
                        let params = func.params in
                        let rec type_param (params : (string * typ) list) (b: expr list ) =
                                match params, b with
                                | [], [] -> func.return
                                | hd::tl1, e::tl2 -> 
                                                let (s, t) = hd in
                                                let te = type_expr e envs in
                                                if (te = t) then type_param tl1 tl2 else failwith "type error"
                                | _ -> failwith "type error"
                        in
                        type_param params b


let rec type_instr i envs =
        match i with
        | Putchar(x) -> 
                        let tx = type_expr x envs in
                        if tx = Int then Void
                        else failwith "type error"
        | Set(x,e) -> 
                        let te = type_expr e envs in
                        let tx = search_tables envs x in
                        if tx = te then Void else failwith "type error"
        | If(e,s1,s2)->
                        let te = type_expr e envs in
                        if te = Bool then 
                               ( if ((type_seq s1 envs = Void) && (type_seq s2 envs = Void)) then Void else failwith "type error" )
                                else failwith "type error" 
        |While(e,s)-> let te = type_expr e envs in
                      if te = Bool then
                              if type_seq s envs = Void then Void else failwith "type error"
                              else failwith "type error"
        | Return(e) ->  let te = type_expr e envs in
                        let (_, env2, _, currentFunction) = envs in
                        let func = Hashtbl.find env2 currentFunction in
                        if func.return = te then Void else failwith "type error"
        | Expr(e) ->   type_expr e envs

and type_seq s envs : typ = 
        match s with
                | r :: s -> let ti = type_instr r envs in
                            if ti = Void then type_seq s envs
                            else failwith "type error"
                | [] -> Void

let rec type_variables l envs = 
        match l with 
        | [] -> Void
        | hd::tl -> 
                        let (s, t, e) = hd in
                        let te = type_expr e envs in
                        if te = t then type_variables tl envs  else failwith "type error"

let rec type_fun_def f envs =
        let locals = f.locals in
        let code = f.code in
        let tcode = type_seq code envs in
        let tlocals = type_variables locals envs in
        if tcode = Void && tlocals = Void then f.return else failwith "type error"

let rec type_functions l envs = 
        let (env1, env2, env3, currentFunction) = envs in
        match l with 
        | [] -> Void
        | hd::tl -> 
                        let s = hd.name in
                        let _ = type_fun_def hd (env1, env2, env3, s) in
                        type_functions tl envs 

let type_prog p envs = 
        let (env1, env2, env3) = envs in
        let envs = (env1, env2, env3, "") in
        let _ = type_variables p.globals envs in 
        let _ = type_functions p.functions envs in
        Void

