extends Map


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cells_unused = [Vector3i(0.0,0.0,0.0),Vector3i(0.0,0.0,-1.0),Vector3i(-1.0,0.0,0.0),Vector3i(-1.0,0.0,-1.0)]
	fill_container(cells_unused)
