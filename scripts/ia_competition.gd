extends Node

var n_game = 100
var current_game = 0

@onready var ia_blue = preload("res://scenes/ia_basic.tscn").instantiate() as Node
@onready var ia_red = preload("res://scenes/ia.tscn").instantiate() as Node

var ia_game_scene = load("res://scenes/IAScene.tscn")

var win_blue = 0
	
func new_competition():
	current_game = 0
	var turn_count = 0
	win_blue = 0
	while current_game != n_game:
		var instance = ia_game_scene.instantiate()
		add_child(instance)
		instance.set_param(PieceTypes.color.BLUE, false, null, ia_red, ia_blue)
		instance.new_game()
		if instance.get_winner()== PieceTypes.color.BLUE:
			win_blue +=1
		turn_count += instance.get_turn_total()
		instance.queue_free()
		current_game+=1
		print(current_game)
		
		
	print("Pourcentage de win de bleu : " + str(float(win_blue)/float(n_game)))
	print("Nombre de tour moyen : "+str(float(turn_count)/float(n_game)))

func _on_button_pressed() -> void:
	new_competition()
