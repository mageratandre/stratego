extends Node

class_name IA


func setup(map, number_piece, player) -> Dictionary :
	var pieces = list_of_piece(number_piece)
	var cells = list_of_cell(map,player)
	var dict = random_assign(cells,pieces,player)
	return dict

	
func list_of_piece(number_piece):
	var pieces = []
	for i in range(0,len(number_piece)):
		for j in range(number_piece[i]):
			pieces.append(i)
	return pieces
	
func list_of_cell(map,player):
	var cells = []
	if player == PieceTypes.color.RED : 
		cells = map.get_cells_below_or_above(-1,"<")
	else: 
		cells = map.get_cells_below_or_above(0,">")
	return cells
	
func random_assign(cells,pieces,player):
	pieces.shuffle()
	var dict_placement = {}
	for i in range(0,len(cells)):
		var cell = Vector3(float(cells[i].x), 0.0,float(cells[i].z))
		dict_placement[cell] = [pieces[i],player]
	return dict_placement
	
	
func compute_next_move(player,possible_moves,dict_total):
	var keys = possible_moves.keys()
	keys.shuffle()
	var cell_init = keys[0]
	var dest = possible_moves[cell_init]
	dest.shuffle()
	var cell_dest = dest[0]
	return [cell_init,cell_dest]
	
