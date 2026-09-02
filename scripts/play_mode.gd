extends Control

@export var button_pause_play : Button
@export var turn_label : Label
@export var turn_slider : HSlider

var sliding = false

signal go_forward
signal go_backward
signal play_pause
signal slider_value_changed(value)

var icon_play = load("res://assets/images/play.png")
var icon_pause = load("res://assets/images/pause.png")

var play_mode = false

func _on_turn_count_slider_value_changed(value: float) -> void: 
	if sliding : 
		slider_value_changed.emit(value)

func _on_turn_count_slider_drag_started() -> void:
	sliding = true


func _on_turn_count_slider_drag_ended(value_changed: bool) -> void:
	sliding = false


func _on_backward_pressed() -> void:
	go_backward.emit()


func _on_forward_pressed() -> void:
	go_forward.emit()

func set_play_pause_icon():
	play_mode = !play_mode
	if play_mode : 
		button_pause_play.set_button_icon(icon_pause)
	else : 
		button_pause_play.set_button_icon(icon_play)
		
func _on_play_pause_pressed() -> void:
	play_pause.emit()

func set_number_of_turn(texte):
	turn_label.text = texte
	
func set_slider_value(value):
	turn_slider.value = value
