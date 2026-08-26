extends Camera3D

var speed = 20
var bounds = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("position")):
		print(position)
	if(Input.is_action_pressed("camera_move")):
		var delta_x = -delta*speed*(get_viewport().get_visible_rect().size.y/2 - get_viewport().get_mouse_position().y)/get_viewport().get_visible_rect().size.y
		var delta_z = delta*speed*(get_viewport().get_visible_rect().size.x/2 - get_viewport().get_mouse_position().x)/get_viewport().get_visible_rect().size.x
		if (position.z +delta_z < -10) or (position.z + delta_z >10) or (position.x + delta_x <-4) or (position.x + delta_x >15) :
			pass
		else :
			position.z += delta_z
			position.x += delta_x
			
