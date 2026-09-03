extends Node

var n_game = 100
var turn_count = 0
var current_game = 0
var time_average = 0

var to_save = true


@onready var ia_blue = preload("res://scenes/logic_scenes/ia_mid.tscn").instantiate() as Node
@onready var ia_red = preload("res://scenes/logic_scenes/ia_basic.tscn").instantiate() as Node

var game
var ia_game_scene = load("res://scenes/Main_scenes/IAScene.tscn")

var win_blue = 0
	
func new_competition():
	
	while current_game != n_game:
		var time_before = Time.get_ticks_msec()
		game = ia_game_scene.instantiate()
		add_child(game)
		game.set_param(PieceTypes.color.BLUE, to_save, "res://save_file_ia.dat", ia_red, ia_blue)
		game.new_game()
		
		update_and_pursue()
		game.queue_free()
		
		current_game +=1
		time_average += Time.get_ticks_msec()- time_before
		print("Game n° "+str(current_game))

	print("Pourcentage de win de bleu : " + str(float(win_blue)/float(n_game)))
	print("Nombre de tour moyen : "+str(float(turn_count)/float(n_game)))
	print("Temps de jeu moyen : "+str(float(time_average)/float(n_game)))

func update_and_pursue() : 
	
	if game.get_winner()== PieceTypes.color.BLUE:
		win_blue += 1
	else : 
		to_save = false
	turn_count += game.get_turn_total()

func _on_button_pressed() -> void:
	new_competition()
