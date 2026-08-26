extends Node3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var cell : Vector3
signal entered_cell(cell)
signal exited_cell(cell)

func set_cell(cell):
	self.cell = cell
	
func get_cell():
	return cell
	
func set_color(color):
	if mesh_instance_3d.visible : 
		mesh_instance_3d.hide()
	else : 
		mesh_instance_3d.show()
	var mat = mesh_instance_3d.get_active_material(0).duplicate() as StandardMaterial3D
	mat.albedo_color = color
	mesh_instance_3d.set_surface_override_material(0,mat)
	
func _on_mouse_entered() -> void:
	#mesh_instance_3d.show()
	entered_cell.emit(cell)


func _on_mouse_exited() -> void:
	#mesh_instance_3d.hide()
	exited_cell.emit(cell)
