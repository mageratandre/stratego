extends Control

@export var minimap : Control
@export var datasaver : Node

var file_to_read = "res://save_game_ia.txt" 
var n_turn = 0

var dict = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	datasaver.open_file(file_to_read, FileAccess.READ)
	n_turn = datasaver.get_number_of_turn()
	var dict = datasaver.extract_dict_at_position(1045)
	datasaver.close_file()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
