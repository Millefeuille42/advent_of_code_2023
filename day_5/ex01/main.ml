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
    print_endline "Parsing lines...";
    let lines = read_lines "ex01/data.txt" in
    print_endline "Generating seed ranges...";
    let seed_ranges = Seedrange.make_multiple (get_seeds lines) in
    print_endline "Generating mappings...";
    let mappings = [
      get_type_map lines "seed-to-soil";
      get_type_map lines "soil-to-fertilizer";
      get_type_map lines "fertilizer-to-water";
      get_type_map lines "water-to-light";
      get_type_map lines "light-to-temperature";
      get_type_map lines "temperature-to-humidity";
      get_type_map lines "humidity-to-location";
    ] in

    Printf.printf "Computing lowest of %d ranges...%!\n" (List.length seed_ranges);
    let rec get_lowest lowest = function
      | [] -> lowest
      | (range : Seedrange.seed_range) :: rest ->
        Printf.printf "\tComputing range of size %d...\n%!" (range.range) ;
        (* Printf.printf "In range: {%d %d}\n" range.source range.range; *)
        let lowest_of_range = Seedrange.get_lowest mappings range in
        if lowest < 0 || lowest_of_range < lowest then
          get_lowest lowest_of_range rest
        else
          get_lowest lowest rest
    in
    print_int (get_lowest (-1) seed_ranges);
    print_newline ();;