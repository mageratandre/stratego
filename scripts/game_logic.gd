extends Node

# tient compte des tours de jeu, des pieces, des conditions de fin, 
# des conditions de victoire d'une piece sur un autre

var finished  = false
var dict_main : Dictionary
var map : Node3D
var current_player : int

var tour_number = 0

signal piece_move(player,mvt)
signal redraw(player,move,dict)
signal piece_captured(piece1,piece2,winner,tied,cell)
signal end_game(winner,captured)


func set_player(player):
	self.current_player = player

func set_dict(dict):
	self.dict_main = dict 
	
func set_map(map):
	self.map = map
	
func get_finished():
	return finished

func get_player():
	return current_player
	
func compute_possible_moves(player,dict_piece)-> Dictionary:
	var possible_moves = []
	var dict_neighbours = map.get_dict_neighbours()

	for key in dict_piece.keys():
		if dict_piece[key][1] == player:
			
			if dict_piece[key][0] != PieceTypes.types.BOMB and dict_piece[key][0] != PieceTypes.types.BANNER and dict_piece[key][0] != PieceTypes.types.SCOUT : 
				for key_n in dict_neighbours[key].values() : 
					if dict_piece.has(key_n) :
						if dict_piece[key_n][1] != player : 
							possible_moves.append([key,key_n])
					else:
						possible_moves.append([key,key_n])
						
			elif dict_piece[key][0] == PieceTypes.types.SCOUT : 
				for i in range(4) :
					var done_direction = false
					var cell = key
					while !done_direction : 
						if i in dict_neighbours[cell].keys() : 
							var next_cell = dict_neighbours[cell][i]
							if dict_piece.has(next_cell) :
								if dict_piece[next_cell][1] != player : 
									possible_moves.append([key,next_cell])
									done_direction = true
								elif dict_piece[next_cell][1] == player : 
									done_direction = true
							else:
								possible_moves.append([key,next_cell])
							cell = next_cell
						else : 
							done_direction = true
						
	var dict_p_m = get_dict_possible_moves(possible_moves)
	if(dict_p_m.size() == 0):
		if player == PieceTypes.color.BLUE : 
			end_game_function(PieceTypes.color.RED,false)
		else : 
			end_game_function(PieceTypes.color.BLUE,false)
	
	return dict_p_m
	
func get_dict_possible_moves(array)->Dictionary:
	var dict_temp = {}
	for i in range(0,len(array)):
		if array[i][0] not in dict_temp.keys() : 
			dict_temp[array[i][0]] = [array[i][1]]
		else : 
			dict_temp[array[i][0]].append(array[i][1])
	return dict_temp
	
func move_piece(player,mvt,dict_main)-> Dictionary:
	var piece = dict_main[mvt[0]]
	dict_main.erase(mvt[0])
	piece_move.emit(player,mvt)
	if dict_main.has(mvt[1]):
		var piece_ennemy = dict_main[mvt[1]]
		var winner = fight(piece,piece_ennemy)
		if winner == [null] : 
			dict_main.erase(mvt[1])
			piece_captured.emit(piece,piece_ennemy,piece,true,mvt[1])
		else : 
			dict_main[mvt[1]] = [winner[0],winner[1],1]  #on revele la piece
			if(piece_ennemy[0] == PieceTypes.types.BANNER):
				end_game_function(player,true)
			else : 
				piece_captured.emit(piece,piece_ennemy,winner,false,mvt[1])
	else : 
		if(mvt[0].x != mvt[1].x +1.0 and mvt[0].x != mvt[1].x -1.0 and mvt[0].z != mvt[1].z +1.0 and mvt[0].z != mvt[1].z -1.0):
			dict_main[mvt[1]] = [piece[0],piece[1],1] #on revele le scout
		else : 
			dict_main[mvt[1]] = piece
	redraw.emit(player,mvt,dict_main)
	
	current_player = get_ennemy_player(player)
	tour_number +=1
	
	return dict_main
	
func get_ennemy_player(player) : 
		var other_player
		if player == PieceTypes.color.BLUE:
			other_player = PieceTypes.color.RED
		else : 
			other_player = PieceTypes.color.BLUE
		return other_player
		
func fight(piece1 : Array,piece2 : Array)-> Array:
	if (check_bomb(piece1,piece2)[0]):
		return check_bomb(piece1,piece2)[1]
	elif (check_bomb(piece2,piece1)[0]):
		return check_bomb(piece2,piece1)[1]
	elif check_spy(piece1,piece2)[0]:
		return check_spy(piece1,piece2)[1]
	elif check_spy(piece2,piece1)[0]:
		return check_spy(piece2,piece1)[1]
	else : 
		var p1 = score(piece1)
		var p2 = score(piece2)
		if p1>p2:
			return piece1
		if p1<p2 :
			return piece2
		else :
			return [null]


func score(piece)-> int:
	if PieceTypes.types.MARSHAL == piece[0] : 
		return 12
	elif PieceTypes.types.GENERAL == piece[0] : 
		return 11
	elif PieceTypes.types.COLONEL == piece[0] : 
		return 10
	elif PieceTypes.types.MAJOR == piece[0] : 
		return 9
	elif PieceTypes.types.CAPTAIN == piece[0] : 
		return 8
	elif PieceTypes.types.LIEUTENANT == piece[0] : 
		return 7
	elif PieceTypes.types.SERGEANT == piece[0] : 
		return 6
	elif PieceTypes.types.MINER == piece[0] : 
		return 5
	elif PieceTypes.types.SCOUT == piece[0] : 
		return 4
	elif PieceTypes.types.SPY == piece[0] : 
		return 3
	else : 
		return 1
		
func check_bomb(piece1, piece2):
	if piece1[0] == PieceTypes.types.BOMB : 
		if piece2[0] == PieceTypes.types.MINER : 
			return [true,piece2]
		else : 
			return [true,piece1]
	else:
		return [false]
			
func check_spy(piece1,piece2):
	if piece1[0] == PieceTypes.types.SPY:
		if piece2[0] == PieceTypes.types.MARSHAL : 
			return [true,piece1]
		else : 
			return [false]
	else : 
		return [false]
		
func end_game_function(winner,captured):
	finished = true
	end_game.emit(winner,captured)
	
	
