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
    let lowest = ref (-1) in
    let lock = Mutex.create() in

    let get_lowest (range : Seedrange.seed_range) =
      (* 
        * This is absolutely not the optimal way of doing this.
        * The optimal way would be to use Sankey diagrams logic to compute only what is necessary, like: 
        *   - getting the lowest seed number
        *   - getting the lowest location mapping that applies to a seed
        *   - comparing the two results
        * This way, the overall complexity will be (almost) independant of the number of seeds.
        * Which would give sub second result almost every time.
      *)
      Printf.printf "\tComputing range of size %d...\n%!" (range.range);
      let lowest_of_range = Seedrange.get_lowest mappings range in
      Mutex.lock lock;
      if !lowest < 0 || lowest_of_range < !lowest then lowest := lowest_of_range;
      Mutex.unlock lock;
    in

    (* 
      * Multi-threading this shit because why not? And it's actually (10 secs) slower, lol
      * From what I managed to understand this is light threading, so no surprises actually. 
      * On the bright side, it limits cpu core load, so my it is way more resilient
      *  on my laptop, which has a tendency to crash when a single core is overloaded
      * Conclusion: Not necessary, still cool to do, learned some stuff :)
    *)
    let rec start_threads acc = function
      | [] -> acc
      | range :: rest ->
        let thread = Thread.create get_lowest range in
        start_threads (thread :: acc) rest
    in
    let threads = start_threads [] seed_ranges in
    List.iter Thread.join threads;
    print_int (!lowest);
    print_newline ();;
