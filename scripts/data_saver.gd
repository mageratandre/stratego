extends Node

var file : FileAccess

func open_file(filename,access):
	file = FileAccess.open(filename, access)
	
func write_dict(dict):
	for i in dict.size():
		file.store_line(str(dict.keys()[i],":",dict.values()[i],"\r").replace(" ","")) 
	file.store_line("end :")
	
func close_file():
	file.close()
	
func save_dict(filename,dict_placement):
	open_file(filename,FileAccess.WRITE)
	write_dict(dict_placement)
	close_file()
	
func load_dict(filename) -> Dictionary:
	open_file(filename,FileAccess.READ) #faire en sorte de ne lire qu'un dict
	var dict = extract_dict()
	file.close()
	return dict
	
func get_number_of_turn() -> int:
	var turn_count = file.get_as_text().count("end :")
	return turn_count
	
func extract_dict():
	var dict = extract_dict_at_position(0)
	return dict


func extract_dict_at_position(index: int):
	var dict_temp = {} as Dictionary
	var count = 0

	for i in file.get_as_text().count(":"):
		var line = file.get_line()
		if line == "end :":
			count +=1
		elif count == index : 
			var key = line.split(":")[0] 
			var cell = Vector3(float(key.split(",")[0].trim_prefix("(")),float(key.split(",")[1]),float(key.split(",")[2].trim_suffix(")")))
			var piece = int(line.split(":")[1].trim_prefix("[").trim_suffix("]").split(",")[0])
			var color = int(line.split(":")[1].trim_prefix("[").trim_suffix("]").split(",")[1])
			dict_temp[cell] = [piece,color]
			
	return dict_temp
	
	
	
	
	
	
	
