class_name IADisplay extends Control

@export var minimap : Control
@export var datasaver : Node
@export var map : Node3D

@export var UI : Control



var file_to_read = "res://save_file_ia.dat"

var n_turn = 0
var current_turn = 0
var time_between_change = 0.05

var dict = {}

var playing = false

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	
	for i in range(0,map.get_node("Container").get_child_count()):
		minimap.add_cell(map.get_node("Container").get_child(i).get_cell())
	
	minimap.draw_cells()
	
	get_number_of_turn()
	
	UI.set_number_of_turn(str(current_turn)+"/"+str(n_turn))
	UI.set_slider_value(0)
	
	UI.go_forward.connect(_on_forward_pressed)
	UI.go_backward.connect(_on_backward_pressed)
	UI.play_pause.connect(_on_play_pause_pressed)
	UI.slider_value_changed.connect(on_slider_value_changed)
	
	load_turn(current_turn)

	
func load_turn(index : int):
	datasaver.open_file(file_to_read, FileAccess.READ)
	dict = datasaver.extract_dict_at_position(index+1)
	datasaver.close_file()
		
	minimap.draw_pieces(dict)
	
	UI.set_number_of_turn(str(index)+"/"+str(n_turn))
	change_slider()

func get_number_of_turn():
	datasaver.open_file(file_to_read, FileAccess.READ)
	n_turn = datasaver.get_number_of_turn(file_to_read)-1
	datasaver.close_file()
	
func change_current_turn(turn):
	if turn >=0 and turn <= n_turn:
		current_turn = turn
		load_turn(current_turn)
		
func _on_backward_pressed() -> void:
	if playing : 
		change_current_turn(0)
		set_playing()
	else:
		change_current_turn(current_turn-1)

func set_playing():
	playing = !playing
	UI.set_play_pause_icon()
		
func _on_play_pause_pressed() -> void:
	set_playing()
	main_loop()
		

func _on_forward_pressed() -> void:
	if playing : 
		change_current_turn(n_turn)
		set_playing()
	else:
		change_current_turn(current_turn+1)

func change_slider(): 
	UI.set_slider_value((float(current_turn)/float(n_turn))*100)

func on_slider_value_changed(value):
	print(value)
	change_current_turn(int(value*((n_turn+1)/100.0)))
	
func main_loop():
	while playing : 
		change_current_turn(current_turn+1)
		await get_tree().create_timer(time_between_change).timeout
