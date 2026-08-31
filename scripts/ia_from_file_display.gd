extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene = load("res://scenes/IADisplay.tscn")
	var instance = scene.instantiate() as IADisplay
	instance.set_mode(0)
	add_child(instance)
	instance.init()
