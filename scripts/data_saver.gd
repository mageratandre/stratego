extends Node

var file : FileAccess

func open_file(filename,access):
	file = FileAccess.open(filename, access)
	
func write_dict(dict):
	file.store_var(dict,true)
	
func close_file():
	file.close()
	
func save_dict(filename,dict_placement):
	open_file(filename,FileAccess.WRITE)
	write_dict(dict_placement)
	close_file()
	
func load_dict(filename) -> Dictionary:
	open_file(filename,FileAccess.READ) #faire en sorte de ne lire qu'un dict
	var dict = extract_dict()
	close_file()
	return dict
	
func get_number_of_turn(filename) -> int:
	var turn_count = 0
	
	while file.get_position() != file.get_size(filename) :
		file.get_var(true)
		turn_count +=1
		
	close_file()
	open_file(filename,FileAccess.READ)
	
	return turn_count
	
func extract_dict():
	var dict = extract_dict_at_position(1)
	return dict


func extract_dict_at_position(index: int):
	var content
	for i in range(0,index):
		content = file.get_var(true)
			
	return content
	
	
	
	
	
	
	
