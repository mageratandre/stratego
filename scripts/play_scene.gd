extends Node3D

@export var datasaver : Node
@export var spawner : Node3D
@export var map : Node3D
@export var minimap : Control
@export var ia : Node
@export var gamelogic : Node
@export var message_display : Control
@export var piece_captured_list : Control

var possible_moves : Dictionary
var cell = null
var cell_active = null
var known_cell = []
var time_to_wait = 1
var mvt = []

signal mvt_picked

var dict_total

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	dict_total = creation_dict_total()
	draw_all_pieces(dict_total)
	for i in range(0,map.get_node("Container").get_child_count()):
		map.get_node("Container").get_child(i).entered_cell.connect(set_cell)
		map.get_node("Container").get_child(i).exited_cell.connect(quit_cell)
		
		minimap.add_cell(map.get_node("Container").get_child(i).get_cell())
		
	minimap.draw_cells()
	minimap.draw_pieces(dict_total)
	new_game()
	
func new_game():
	gamelogic.set_player(PieceTypes.color.BLUE)
	gamelogic.set_map(map)
	gamelogic.set_dict(dict_total)
	
	while !gamelogic.get_finished():
		if gamelogic.get_player() == PieceTypes.color.BLUE:
			possible_moves = gamelogic.compute_possible_moves(PieceTypes.color.BLUE,dict_total)
			await mvt_picked
			dict_total = gamelogic.move_piece(PieceTypes.color.BLUE, mvt, dict_total)
		else :
			possible_moves = gamelogic.compute_possible_moves(PieceTypes.color.RED,dict_total)
			mvt = ia.compute_next_move(PieceTypes.color.RED, possible_moves,dict_total)
			await get_tree().create_timer(time_to_wait).timeout
			dict_total = gamelogic.move_piece(PieceTypes.color.RED,mvt,dict_total)
		
		
func creation_dict_total()-> Dictionary:
	var dict_total = {}
	var dict_player = datasaver.load_dict("res://save_game.txt")
	for key in dict_player.keys():
		dict_total[key] = dict_player[key]
	var dict_ia = ia.setup(map, [1,6,1,1,1,2,3,4,4,4,5,8],PieceTypes.color.RED)
	dict_total.merge(dict_ia)
	return dict_total
	
func draw_all_pieces(dict) : 
	for i in range(spawner.get_child_count()):
		spawner.get_child(i).remove()
	for key in dict.keys():
		var pos = map.get_global(key)
		if key in known_cell:
			spawner.create(dict[key][0],pos.x,pos.z,key,dict[key][1], true)
		else : 
			spawner.create(dict[key][0],pos.x,pos.z,key,dict[key][1], false)
		
func set_cell(_cell):
	if _cell in possible_moves.keys() : #soit c'est une des clés
		cell = _cell
	elif cell_active != null:
		if _cell in possible_moves[cell_active]: #soit c'est un voisin de la cell active
			cell = _cell

func quit_cell(cell):
	self.cell = null
	
func set_active_cell(_cell):
	if cell_active != null : 
		hide_neighbours(cell_active,possible_moves[cell_active])
	cell_active = _cell
	show_neighbours(cell_active,possible_moves[cell_active])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("place_piece"):
		if cell != null : 
			if cell_active == null:
				set_active_cell(cell)
			elif cell_active != null:
				if cell not in possible_moves[cell_active]:
					set_active_cell(cell)
				elif cell_active != null and cell in possible_moves[cell_active]: 
					mvt = [cell_active,cell]
					hide_neighbours(cell_active,possible_moves[cell_active])
					possible_moves = {}
					cell_active = null
					quit_cell(cell)
					mvt_picked.emit()
					
		

func show_neighbours(_cell,neighbours):
	for i in range(0,map.get_node("Container").get_child_count()):
		if map.get_node("Container").get_child(i).get_cell() in neighbours:
			map.get_node("Container").get_child(i).set_color(Color(1.0, 1.0, 1.0, 1.0))
		elif map.get_node("Container").get_child(i).get_cell() == _cell : 
			map.get_node("Container").get_child(i).set_color(Color(0.38, 0.0, 0.711, 1.0))

func hide_neighbours(_cell, neighbours) : 
	for i in range(0,map.get_node("Container").get_child_count()):
		if map.get_node("Container").get_child(i).get_cell() in neighbours:
			map.get_node("Container").get_child(i).set_color(Color(1.0, 1.0, 1.0, 0.0))
		elif map.get_node("Container").get_child(i).get_cell() == _cell : 
			map.get_node("Container").get_child(i).set_color(Color(0.38, 0.0, 0.711, 0.0))

func _on_minimap_button_pressed() -> void:
	if minimap.visible:
		minimap.hide()
	else : 
		minimap.show()

		

func _on_game_logic_piece_move(player,mvt,dict: Variant) -> void:
	if player == PieceTypes.color.RED:
		if mvt[0] in known_cell:
			known_cell.erase(mvt[0])
			known_cell.append(mvt[1])
	draw_all_pieces(dict)
	minimap.draw_pieces(dict)


func _on_game_logic_piece_captured(piece1: Variant, piece2: Variant, winner: Variant, tied: Variant, cell) -> void:
	if tied : 
		message_display.message("[color=blue]"+get_name_piece(piece1[0])+"[/color]"+" and " +"[color=red]"+get_name_piece(piece1[0])+"[/color]"+ " captured each others")
		piece_captured_list.add_piece(piece1)
		piece_captured_list.add_piece(piece2)
	else:
		if cell not in known_cell and winner[1] == PieceTypes.color.RED:
			known_cell.append(cell)
		elif cell in known_cell and winner[1] == PieceTypes.color.BLUE:
			known_cell.erase(cell)
		var win_s = get_name_piece(winner[0])
		var los_s = ""
		var win_c = get_color_piece(winner[1])
		var los_c = ""
		if winner == piece1:
			los_s = get_name_piece(piece2[0])
			los_c = get_color_piece(piece2[1])
			piece_captured_list.add_piece(piece2)
		else : 
			los_s = get_name_piece(piece1[0])
			los_c = get_color_piece(piece1[1])
			piece_captured_list.add_piece(piece1)
				
		message_display.message("[color="+win_c+"]"+win_s+"[/color] captured "+"[color="+los_c+"]"+los_s+"[/color]")
			
func get_name_piece(piece_int) -> String:
	
	if piece_int == PieceTypes.types.MARSHAL:
		return "Marshal"
	elif piece_int == PieceTypes.types.BANNER:
		return "Banner"
	elif piece_int == PieceTypes.types.BOMB:
		return "Bomb"
	elif piece_int == PieceTypes.types.CAPTAIN:
		return "Captain"
	elif piece_int == PieceTypes.types.COLONEL:
		return "Colonel"
	elif piece_int == PieceTypes.types.GENERAL:
		return "General"
	elif piece_int == PieceTypes.types.LIEUTENANT:
		return "Lieutenant"
	elif piece_int == PieceTypes.types.MAJOR:
		return "Major"
	elif piece_int == PieceTypes.types.MINER:
		return "Miner"
	elif piece_int == PieceTypes.types.SCOUT:
		return "Scout"
	elif piece_int == PieceTypes.types.SPY:
		return "Spy"
	else:
		return "Sergeant"
		
func get_color_piece(color) : 
	if color == PieceTypes.color.BLUE : 
		return "blue"
	else : 
		return "red"
	
func _on_game_logic_end_game(winner: Variant) -> void:
	var color = get_color_piece(winner)
	message_display.message("[color="+color+"]Player "+str(winner)+"[/color] Wins !!!")


func _on_ia_mvt_picked(mvt: Variant) -> void:
	pass # Replace with function body.
