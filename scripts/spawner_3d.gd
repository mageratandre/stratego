extends Node3D
	
func create(type,x,z,cell, color,known):
	var scene = load("res://scenes/piece.tscn")
	var instance = scene.instantiate()
	instance.position.x = x
	instance.position.z = z
	instance.position.y = 1.1
	instance.set_icon(type)
	instance.set_cell(cell)
	instance.set_color(color)
	if color == PieceTypes.color.RED : 
		instance.set_rot(180.0)
	if known :
		instance.rotation_degrees.y +=180
	add_child(instance)
	
func remove(cell):
	for i in range(0,get_child_count()):
		if get_child(i).get_cell() == cell:
			get_child(i).remove()
