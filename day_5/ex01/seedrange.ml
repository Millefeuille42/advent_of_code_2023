type seed_range = {
  source : int;
  range : int;
}

let make source range = {
  source = source;
  range = range;
}

let make_multiple seeds =
  let rec subroutine acc source = function
    | [] -> acc
    | number :: rest ->
      if source < 0 then
        subroutine acc number rest
      else 
        subroutine ((make source number) :: acc) (-1) rest
  in
  subroutine [] (-1) seeds
    
let to_list range =
  let rec subroutine current acc remaining =
    if remaining <= 0 then
      acc
    else 
      subroutine (current + 1) (current :: acc) (remaining - 1)
  in
  subroutine range.source [] range.range

let get_lowest mappings range =
  Gc.full_major();
  let start_time = Sys.time () in

  let rec subroutine mappings lowest = function
    | [] -> lowest
    | seed :: rest ->
      (* Printf.printf "\tTesting %d\n" seed; *)
      let location = Resourcemap.get_resource_loc seed mappings in
      if lowest < 0 || location < lowest then
        (
          (* Printf.printf "\t\t\tgot the lowest\n"; *)
          subroutine mappings location rest)
      else 
        subroutine mappings lowest rest
  in
  let res = subroutine mappings (-1) (to_list range) in
  let end_time = Sys.time () in
  Printf.printf "\t\ttook %f seconds...\n%!" (end_time -. start_time) ;
  res
