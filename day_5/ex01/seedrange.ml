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
    
let get_lowest mappings range =
  let start_time = Sys.time () in
  let start = range.source in
  let len = range.range + start in
  let lowest = ref (-1) in
  for seed = start to len do
    let location = Resourcemap.get_resource_loc seed mappings in
    if !lowest < 0 || location < !lowest then
      lowest := location
  done;
  let end_time = Sys.time () in
  Printf.printf "\t\ttook %f seconds...\n%!" (end_time -. start_time) ;
  !lowest
