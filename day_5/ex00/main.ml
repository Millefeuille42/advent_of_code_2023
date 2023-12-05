open Utils;;

let get_seeds lines =
  let rec extract_seeds = function
    | [] -> []
    | line :: rest ->
      if (String.sub line 0 5) = "seeds" then
        extract_numbers line
      else
        extract_seeds rest
  in
  extract_seeds lines

let get_type_map lines value =
  let rec extract_type_map acc parse = function
    | [] -> acc
    | line :: rest ->
      if parse then
        let numbers = extract_numbers line in
        if List.length numbers <> 3 then
          acc
        else
          let t = Resourcemap.make (List.nth numbers 0) (List.nth numbers 1) (List.nth numbers 2) in
          extract_type_map (t :: acc) parse rest
        else if has_prefix line value then
          extract_type_map acc true rest
        else
          extract_type_map acc parse rest
  in
  extract_type_map [] false lines

let () =
    let lines = read_lines "./ex00/data.txt" in
    let seeds = get_seeds lines in
    let mappings = [
      get_type_map lines "seed-to-soil";
      get_type_map lines "soil-to-fertilizer";
      get_type_map lines "fertilizer-to-water";
      get_type_map lines "water-to-light";
      get_type_map lines "light-to-temperature";
      get_type_map lines "temperature-to-humidity";
      get_type_map lines "humidity-to-location";
    ] in

    let rec get_lower lower = function
      | [] -> lower
      | seed :: rest ->
        let location = Resourcemap.get_resource_loc seed mappings in
        if lower < 0 || location < lower then
          get_lower location rest
        else
          get_lower lower rest
    in
    print_int (get_lower (-1) seeds);
    print_newline ();;