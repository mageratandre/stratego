extends Node

var n_game = 10
var turn_count = 0
var current_game = 0
var ref_to_game


@onready var ia_blue = preload("res://scenes/logic_scenes/ia_mid.tscn").instantiate() as Node
@onready var ia_red = preload("res://scenes/logic_scenes/ia_basic.tscn").instantiate() as Node

@export var game : Node

var win_blue = 0
	
func new_competition():
	
	while current_game != n_game:
		game.new_game()
		await game.game_ended
		update_and_pursue()

	print("Pourcentage de win de bleu : " + str(float(win_blue)/float(n_game)))
	print("Nombre de tour moyen : "+str(float(turn_count)/float(n_game)))

func update_and_pursue() : 
	
	if game.get_winner()== PieceTypes.color.BLUE:
		win_blue += 1
	turn_count += ref_to_game.get_turn_total()
	current_game += 1
	
func _ready() -> void:

	game.set_param(PieceTypes.color.BLUE, false, null, ia_red, ia_blue)
	new_competition()
