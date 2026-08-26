extends Control

@export var label : RichTextLabel
@export var timer : Timer 

func message(string):
	show()
	label.text = string
	timer.start()

func _on_timer_timeout() -> void:
	hide()
