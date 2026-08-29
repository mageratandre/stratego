extends Control

@export var minimap : Control
@export var datasaver : Node
@export var map : Node3D

@export var play_pause_button : Button
@export var turn_display_label : Label
@export var turn_slider : HSlider


var file_to_read = "res://save_game_ia.txt" 
var icon_play = load("res://play.png")
var icon_pause = load("res://pause.png")

var n_turn = 0
var current_turn = 1
var time_between_change = 0.05

var dict = {}

var playing = false
var sliding = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in range(0,map.get_node("Container").get_child_count()):
		minimap.add_cell(map.get_node("Container").get_child(i).get_cell())
	
	get_number_of_turn()
	turn_display_label.text = str(current_turn)+"/"+str(n_turn)
	minimap.draw_cells()
	load_turn(current_turn)

	
func load_turn(index : int):
	datasaver.open_file(file_to_read, FileAccess.READ)
	dict = datasaver.extract_dict_at_position(index)
	datasaver.close_file()
	minimap.draw_pieces(dict)
	turn_display_label.text = str(index)+"/"+str(n_turn)
	if !sliding : 
		turn_slider.value = (float(index)/float(n_turn))*100

func get_number_of_turn():
	datasaver.open_file(file_to_read, FileAccess.READ)
	n_turn = datasaver.get_number_of_turn()-1
	datasaver.close_file()
	
func change_current_turn(turn):
	if turn >=1 and turn <= n_turn:
		current_turn = turn
		load_turn(current_turn)
		
func _on_backward_pressed() -> void:
	if playing : 
		change_current_turn(1)
		set_playing(!playing)
	else:
		change_current_turn(current_turn-1)

func set_playing(_playing):
	if _playing : 
		play_pause_button.set_button_icon(icon_pause)
		self.playing = true
	else : 
		play_pause_button.set_button_icon(icon_play)
		self.playing = false
		
func _on_play_pause_pressed() -> void:
	set_playing(!playing)
	main_loop()
		

func _on_forward_pressed() -> void:
	if playing : 
		change_current_turn(n_turn)
		set_playing(!playing)
	else:
		change_current_turn(current_turn+1)


func _on_turn_count_slider_value_changed(value: float) -> void: 
	if sliding : 
		change_current_turn(int(1+value*((n_turn-1)/100.0)))

func main_loop():
	while playing : 
		change_current_turn(current_turn+1)
		await get_tree().create_timer(time_between_change).timeout


func _on_turn_count_slider_drag_started() -> void:
	sliding = true


func _on_turn_count_slider_drag_ended(value_changed: bool) -> void:
	sliding = false
