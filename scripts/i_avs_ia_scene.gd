extends Node


@export var gamelogic : Node
@export var map : Node3D
@export var datasaver : Node
@export var ia_display : IADisplay

var pieces = [1,6,1,1,1,2,3,4,4,4,5,8]

var winner

var turn_count = 0
var piece_captured = 0
var current_player 

var saving
var save_file
var ia_red
var ia_blue

var dict_total

func _ready() -> void:
	set_param(PieceTypes.color.BLUE,true,"res://save_file_ia.dat", 
	load("res://scenes/logic_scenes/ia.tscn").instantiate(),
	load("res://scenes/logic_scenes/ia_mid.tscn").instantiate())
	ia_display.set_mode(1)
	ia_display.init()
	new_game()

func set_param(_first_player, _saving, _filename, _ia_red, _ia_blue) -> void:
	
	self.current_player = _first_player
	self.saving = _saving
	self.ia_red = _ia_red
	self.ia_blue = _ia_blue
	self.save_file =_filename
	

func new_game():
	
	dict_total = ia_red.setup(map,pieces,PieceTypes.color.RED) as Dictionary
	dict_total.merge(ia_blue.setup(map,pieces,PieceTypes.color.BLUE))
	saver("open")
	
	gamelogic.set_player(current_player)
	gamelogic.set_map(map)
	gamelogic.set_dict(dict_total)
	saver("save")
	while !gamelogic.get_finished():
		
		ia_display.set_dict(dict_total)
		ia_display.load_turn(turn_count)
		
		if gamelogic.get_player() == PieceTypes.color.BLUE:
			one_turn(PieceTypes.color.BLUE)
		else :
			one_turn(PieceTypes.color.RED)
		update_stat()
		
		await ia_display.next_turn

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
			
			
			
		
