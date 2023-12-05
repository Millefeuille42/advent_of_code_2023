type resource_map = {
  destination : int;
  source : int;
  range : int;
}

let make destination source type_range = {
  destination = destination;
  source = source;
  range = type_range;
}

let in_map map source = map.source <= source && (map.source + map.range) > source
let source_to_destination map source = map.destination + (source - map.source)

let rec source_to_destination_from_list source = function
  | [] -> source
  | map :: rest ->
    if not (in_map map source) then
      source_to_destination_from_list source rest
    else
      source_to_destination map source

let rec get_resource_loc resource = function
  | [] -> resource
  | map :: rest ->
    let new_resource = source_to_destination_from_list resource map in
    get_resource_loc new_resource rest

let print map =
  Printf.printf "{\n  destination: %d\n  source: %d\n  range: %d\n}\n" map.destination map.source map.range