class_name IA_mid extends IA_basic

@export var gamelogic : Node

var astar_grid : AStarGrid2D

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
	
func compute_next_move(player,possible_moves,dict_total):
	var array_move = []
	var points = []
	for cell in possible_moves.keys() : 
		for cell_2 in possible_moves[cell]:
			array_move.append([cell,cell_2])
			
	generate_astar_grid(dict_total)
	for move in array_move:
		#check si on a une victoire garantie ou une défaite garantie
		if dict_total.has(move[1]):
			if dict_total[move[1]][2]==1:
				var winner = gamelogic.fight(dict_total[move[0]],dict_total[move[1]])
				if winner == [null]:
					points.append(0)
				elif winner[1] == player:
					points.append(1)
				else : 
					points.append(-1)
			else : 
				if dict_total[move[0]][0] == PieceTypes.types.SCOUT or dict_total[move[0]][0] == PieceTypes.types.SERGEANT:
					points.append(0.5)
				else : 
					points.append(0.01)
					
		# check si on peut arriver à une victoire garantie
		else : 
			var cells = dict_total.keys()
			var weights = []
			for cell in cells:
				if dict_total[cell][1]!= player and dict_total[cell][2] == 1:
					var winner = gamelogic.fight(dict_total[move[0]],dict_total[cell])
					if winner != [null]:
						if winner[1]==player : 
							var path = astar_grid.get_point_path(Vector2i(move[1].x,move[1].y),Vector2i(cell.x,cell.y))
							if len(path)>0:
								print(path)
								weights.append(2.0*(1.0/float(len(path))))
							else : 
								weights.append(0)
						else : 
							weights.append(0)
					else : 
						weights.append(0)
				else : 
					weights.append(0)
			points.append(weights.max())
		
		if player == PieceTypes.color.BLUE : 
			if move[0].x > move[1].x:
				points[-1]+=0.01 
		else :
			if move[0].x < move[1].x:
				points[-1]+=0.01 
	var best_moves = []
	
	for i in range(0,len(points)):
		if points[i] == points.max():
			best_moves.append(i)
	
	var final_move = array_move[best_moves.pick_random()]
	
	return final_move
							 
						
				
func generate_astar_grid(dict_total):
	var cells = dict_total.keys()
		
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(Vector2i(-5,-5),Vector2i(10,10))
	astar_grid.cell_size = Vector2(1,1)
	
	astar_grid.update()
	
	var cells_unused = [Vector2i(0.0,1.0),Vector2i(0.0,2.0),Vector2i(-1.0,1.0),Vector2i(-1.0,2.0),
	Vector2i(0.0,-2.0),Vector2i(0.0,-3.0),Vector2i(-1.0,-2.0),Vector2i(-1.0,-3.0)]
	for cell in cells_unused:
		astar_grid.set_point_solid(cell)
	for cell in cells : 
		astar_grid.set_point_solid(Vector2i(cell.x,cell.z))
		
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	

				
