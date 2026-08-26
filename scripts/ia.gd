extends Node

var map
var dict
@export var timer : Timer

func setup(map, number_piece, player)->Dictionary:
	var pieces = []
	for i in range(0,len(number_piece)):
		for j in range(number_piece[i]):
			pieces.append(i)
	pieces.shuffle()
	var dict_placement = {}
	var cells_above
	if player == PieceTypes.color.RED : 
		cells_above = map.get_cells_below_or_above(-1,"<")
	else: 
		cells_above = map.get_cells_below_or_above(0,">")
	for i in range(0,len(cells_above)):
		var cell = Vector3(float(cells_above[i].x), 0.0,float(cells_above[i].z))
		dict_placement[cell] = [pieces[i],player]
	return dict_placement
	
func compute_next_move(player,possible_moves):
	var keys = possible_moves.keys()
	keys.shuffle()
	var cell_init = keys[0]
	var dest = possible_moves[cell_init]
	dest.shuffle()
	var cell_dest = dest[0]
	
	return [cell_init,cell_dest]
	
