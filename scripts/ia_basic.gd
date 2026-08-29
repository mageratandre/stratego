extends IA

var free_cells_left : Array
var free_pieces_left : Array
var heatmap : Array

var dict_setup
	
func setup(map, number_piece, player) -> Dictionary:
	
	var cells = list_of_cell(map,player)
	var pieces = list_of_piece(number_piece)
	var dict = basic_assign(map,cells,pieces,player)
	return dict

func basic_assign(map,cells,pieces,player) : 
	dict_setup = {}
	free_cells_left = cells
	free_pieces_left = pieces
	heatmap = cell_heatmap_x(cells)
	
	#on place le drapeau sur la dernière ligne sur une case au hasard
	var cells_last_line = []
	for i in range(0,len(heatmap)):
		if heatmap[i]==1.0:
			cells_last_line.append(free_cells_left[i])
	cells_last_line.shuffle()
	var cell_flag = cells_last_line[0]
	place_piece(PieceTypes.types.BANNER,cell_flag,player)
	
	#on met des bombes tout autour
	var dict_neighbour = map.get_dict_neighbours()
	var cells_bomb = dict_neighbour[Vector3(float(cell_flag.x), 0.0,float(cell_flag.z))].values()
	for cell in cells_bomb:
		var cell_bad_format = Vector3i(int(cell.x),int(0.0),int(cell.z))
		place_piece(PieceTypes.types.BOMB,cell_bad_format,player)
	
	#on place le reste des pieces au hasard
	free_pieces_left.shuffle()
	while(len(free_pieces_left)>0):
		place_piece(free_pieces_left[0],free_cells_left[0],player)
	
	return dict_setup

	
func place_piece(piece,_cell,player):
	var cell_good_format = Vector3(float(_cell.x), 0.0,float(_cell.z))
	dict_setup[cell_good_format] = [piece,player]
	var i = free_cells_left.find(_cell)
	heatmap.remove_at(i)
	free_pieces_left.erase(piece)
	free_cells_left.erase(_cell)


func cell_heatmap_x(cells):
	var x_max = abs(cells[0].x)
	var x_min = abs(cells[0].x)
	
	for i in range(1,len(cells)) : 
		var temp = abs(cells[i].x)
		if temp>x_max:
			x_max = temp
		elif temp<x_min:
			x_min = temp
	heatmap = []
	for cell in cells:
		var val = (abs(cell.x)-x_min)/float(x_max-x_min)
		heatmap.append(val)
	return heatmap
	
func compute_next_move(player,possible_moves,dict_total):
	var cells_init = possible_moves.keys() as Array
	if player == PieceTypes.color.RED:
		cells_init.sort_custom(func(a, b): return a.x > b.x)
	else : 
		cells_init.sort_custom(func(a, b): return a.x < b.x)
	if len(cells_init)>1 : 
		cells_init.resize(len(cells_init)/4)
	cells_init.shuffle()
	var cell_init = cells_init[0]

	var cells_dest = possible_moves[cell_init] as Array
	var add_cell
	if player == PieceTypes.color.BLUE:
		for cell in cells_dest:
			if cell.x< cell_init.x:
				add_cell = cell
	else : 
		for cell in cells_dest:
			if cell.x> cell_init.x:
				add_cell = cell
	if add_cell != null:
		cells_dest.append_array([add_cell,add_cell,add_cell,add_cell])
	cells_dest.shuffle()
	var cell_dest = cells_dest[0]
	return[cell_init,cell_dest]

	
		
