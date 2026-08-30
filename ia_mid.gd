class_name IA_mid extends IA_basic

@export var gamelogic : Node


func setup(map, number_piece, player) -> Dictionary:
	
	var cells = list_of_cell(map,player)
	var pieces = list_of_piece(number_piece)
	var dict = mid_assign(map,cells,pieces,player)
	return dict
	
func mid_assign(map,cells,pieces,player) : 
	dict_setup = {}
	free_cells_left = cells
	free_pieces_left = pieces
	heatmap = cell_heatmap_x(cells)
	
	#on place le drapeau sur la dernière ligne sur une case au hasard
	flag_on_last_line(player)
	
	#on met des bombes tout autour
	bomb_around_flag(map,player)
	
	#on met le reste des bombes dans le fond couche 3/4
	bomb_on_last_layers(player)
	
	#on place le reste des pieces au hasard
	rest_of_piece_random(player)
	
	return dict_setup
	
func bomb_on_last_layers(player):
	var cells_concerned = []
	for i in range(0,len(heatmap)):
		if heatmap[i]>0.5:
			cells_concerned.append(free_cells_left[i])
	cells_concerned.shuffle()
	for i in range(0,free_pieces_left.count(PieceTypes.types.BOMB)):
		place_piece(PieceTypes.types.BOMB,cells_concerned[i],player)
	
