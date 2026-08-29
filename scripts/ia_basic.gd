extends IA


func setup(map, number_piece, player) -> Dictionary:
	
	var cells = list_of_cell(map,player)
	var pieces = list_of_piece(number_piece)
	var dict = basic_assign(cells,pieces)
	
	return dict

func basic_assign(cells,pieces) : 
	var dict ={}
	return dict
