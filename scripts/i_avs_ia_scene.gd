extends Node
@export var gamelogic : Node
@export var ia_red : Node
@export var ia_blue : Node
@export var map : Node3D
@export var datasaver : Node

var pieces = [1,6,1,1,1,2,3,4,4,4,5,8]

var turn_count = 0
var piece_captured = 0
var current_player = PieceTypes.color.BLUE

var saving = true
var save_file = "res://save_game_ia.txt"

var dict_total


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dict_total = ia_red.setup(map,pieces,PieceTypes.color.RED) as Dictionary
	dict_total.merge(ia_blue.setup(map,pieces,PieceTypes.color.BLUE))
	saver("open")
	new_game()
	

func new_game():
	gamelogic.set_player(PieceTypes.color.RED)
	gamelogic.set_map(map)
	gamelogic.set_dict(dict_total)
	
	while !gamelogic.get_finished():
		if gamelogic.get_player() == PieceTypes.color.BLUE:
			one_turn(PieceTypes.color.BLUE)
		else :
			one_turn(PieceTypes.color.RED)
		update_stat()

func one_turn(player) : 
	var possible_moves = gamelogic.compute_possible_moves(player,dict_total)
	var mvt
	if player == PieceTypes.color.RED and !gamelogic.get_finished(): 
		mvt = ia_red.compute_next_move(PieceTypes.color.RED, possible_moves)
		dict_total = gamelogic.move_piece(player,mvt,dict_total)
	if player == PieceTypes.color.BLUE and !gamelogic.get_finished():
		mvt = ia_blue.compute_next_move(PieceTypes.color.BLUE, possible_moves)
		dict_total = gamelogic.move_piece(player,mvt,dict_total)
	
	
func update_stat():
	turn_count +=1
	saver("save")
	
func _on_game_logic_end_game(winner: Variant) -> void:
	print(turn_count)
	saver("close")
	
func saver(MODE):
	if(saving):
		if MODE =="open":
			datasaver.open_file(save_file, FileAccess.READ_WRITE)
		elif MODE == "save":
			datasaver.write_dict(dict_total)
		elif MODE == "close":
			datasaver.close_file()
			
			
			
		
