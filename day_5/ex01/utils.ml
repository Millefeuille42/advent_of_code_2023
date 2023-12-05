let rec print_list_ints lst =
	match lst with
	| [] ->
		  print_newline ()
	| head :: tail ->
	  begin
		  Printf.printf "%d " head;
		  print_list_ints tail
	  end

let rec print_map_ints map =
	match map with
	| [] -> ()
	| head :: tail ->
		  begin
			  print_list_ints head;
			  print_map_ints tail
		  end

let split_by_space line =
  String.split_on_char ' ' line

let has_prefix string prefix = 
  String.length string >= String.length prefix && String.sub string 0 (String.length prefix) = prefix
    
let read_lines filename =
  let channel = open_in filename in
  let rec read_all_lines acc =
    try
      let line = input_line channel in
      read_all_lines (line :: acc)
    with
    | End_of_file ->
      close_in channel;
      List.rev acc
  in
  read_all_lines []

let extract_numbers line =
  let words = split_by_space line in
  let rec extract_numbers_acc acc = function
    | [] -> acc
    | word :: rest ->
      try
        let number = int_of_string word in
        extract_numbers_acc (number :: acc) rest
      with _ -> extract_numbers_acc acc rest
  in
  List.rev (extract_numbers_acc [] words)