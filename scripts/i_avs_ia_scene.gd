extends Node


@export var gamelogic : Node
@export var map : Node3D
@export var datasaver : Node

@export var UI : Control
@export var minimap : Control


var pieces = [1,6,1,1,1,2,3,4,4,4,5,8]

var winner
signal game_ended
signal next_turn_debug

var turn_count
var current_player 

var saving
var save_file
var ia_red
var ia_blue

var dict_total

var debug_mode = false
var playing_debug = false
var time_to_wait_debug = 0.01
var printing = false

func _ready() -> void:    
	reset()
		
	if debug_mode : 
		set_param(PieceTypes.color.BLUE,true,"res://save_file_ia.dat", 
		load("res://scenes/logic_scenes/ia_basic.tscn").instantiate(),
		load("res://scenes/logic_scenes/ia_mid.tscn").instantiate())

		if ia_blue.get_class() == IA_mid.new().get_class():
			ia_blue.to_print_signal.connect(to_print)
		
		UI.go_forward.connect(_on_forward_pressed_debug)
		UI.play_pause.connect(_on_pause_play_pressed)
		
		new_game()
	
func to_print(texte):
	if printing:
		print("Tour n°"+str(turn_count)+" : "+str(texte))

func set_param(_first_player, _saving, _filename, _ia_red, _ia_blue) -> void:
	
	self.current_player = _first_player
	self.saving = _saving
	self.ia_red = _ia_red
	self.ia_blue = _ia_blue
	self.save_file = _filename
	

func reset():
	for i in range(0,map.get_node("Container").get_child_count()):
		minimap.add_cell(map.get_node("Container").get_child(i).get_cell())
	
	minimap.draw_cells()
	
	winner = null
	turn_count = 0

func new_game():
	
	dict_total = ia_red.setup(map,pieces,PieceTypes.color.RED) as Dictionary
	dict_total.merge(ia_blue.setup(map,pieces,PieceTypes.color.BLUE))
	saver("open")
	
	gamelogic.set_player(current_player)
	gamelogic.set_map(map)
	gamelogic.set_dict(dict_total)
	gamelogic.set_finished(false)
	
	saver("save")

	while !gamelogic.get_finished():
		
		minimap.draw_pieces(dict_total)
		UI.set_number_of_turn(str(turn_count)+"/?")
		
		if gamelogic.get_player() == PieceTypes.color.BLUE:
			one_turn(PieceTypes.color.BLUE)
		else :
			one_turn(PieceTypes.color.RED)
		update_stat()
		
		if debug_mode : 
			await next_turn_debug
			
	playing_debug = false

func _on_forward_pressed_debug():
	next_turn_debug.emit()

func _on_pause_play_pressed():
	playing_debug = !playing_debug
	UI.set_play_pause_icon()
	main_loop_debug()

func main_loop_debug():
	while playing_debug : 
		await get_tree().create_timer(time_to_wait_debug).timeout
		next_turn_debug.emit()

func one_turn(player) : 
	var possible_moves = gamelogic.compute_possible_moves(player,dict_total)
	var mvt
	if player == PieceTypes.color.RED and !gamelogic.get_finished(): 
		mvt = ia_red.compute_next_move(PieceTypes.color.RED, possible_moves,dict_total)
		dict_total = gamelogic.move_piece(player,mvt,dict_total)
	if player == PieceTypes.color.BLUE and !gamelogic.get_finished():
		mvt = ia_blue.compute_next_move(PieceTypes.color.BLUE, possible_moves,dict_total)
		dict_total = gamelogic.move_piece(player,mvt,dict_total)
	
	
func update_stat():
	turn_count +=1
	saver("save")
	
func _on_game_logic_end_game(winner: Variant,captured) -> void:
	self.winner = winner
	if captured:
		saver("save")		
	saver("close")

func get_winner():
	return winner
	
func get_turn_total():
	return turn_count
	
func saver(MODE):
	if(saving):
		if MODE =="open":
			datasaver.open_file(save_file, FileAccess.WRITE)
		elif MODE == "save":
			datasaver.write_dict(dict_total)
		elif MODE == "close":
			datasaver.close_file()
			
			
			
		
