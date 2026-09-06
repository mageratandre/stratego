extends IA_mid
class_name IA_minmax

func setup(map, number_piece, player) -> Dictionary:
	var pieces = list_of_piece(number_piece)
	var cells = list_of_cell(map,player)
	var dict = mid_assign(map,cells,pieces,player)
	return dict
	
func compute_next_move(player,possible_moves,dict_total):
	pass
	
