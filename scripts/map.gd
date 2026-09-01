extends Node3D

class_name Map

@export var container : Node3D
@export var ground_tiles : GridMap

enum coord {TOP,RIGHT,BOTTOM,LEFT}

var dict_cell = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cells_unused = [Vector3i(0.0,0.0,1.0),Vector3i(0.0,0.0,2.0),Vector3i(-1.0,0.0,1.0),Vector3i(-1.0,0.0,2.0),
	Vector3i(0.0,0.0,-2.0),Vector3i(0.0,0.0,-3.0),Vector3i(-1.0,0.0,-2.0),Vector3i(-1.0,0.0,-3.0)]

	fill_container(cells_unused)
	init_neighbours()
	
func fill_container(unused):
	for cell in ground_tiles.get_used_cells():
		if cell not in unused:
			var scene = load("res://scenes/visual_scenes/clickable_area.tscn")
			var instance = scene.instantiate()
			instance.position.x = 2*cell.x + ground_tiles.cell_size.x/2
			instance.position.z = 2*cell.z + ground_tiles.cell_size.z/2
			instance.position.y = 0.1 + ground_tiles.cell_size.y/2
			instance.set_cell(cell)
			container.add_child(instance)
	
func get_global(cell):
	return 2*ground_tiles.to_global(cell) + ground_tiles.cell_size/2

func get_cells_below_or_above(limit : int, direction : String )-> Array:
	var cells = []
	for cell in ground_tiles.get_used_cells():
		if direction == "<" : 
			if cell.x <limit:
				cells.append(cell)
		else : 
			if cell.x >limit:
				cells.append(cell)
	return cells

func init_neighbours() : 
	
	for i in range(0, container.get_child_count()):
		var dict_temp = {}
		var cell = container.get_child(i).get_cell()
		for j in range(0, container.get_child_count()):
			var other_cell = container.get_child(j).get_cell()
			if cell.x == other_cell.x +1 and cell.z == other_cell.z:
				dict_temp[coord.BOTTOM] = other_cell
			elif cell.x == other_cell.x -1 and cell.z == other_cell.z:
				dict_temp[coord.TOP] = other_cell
			elif cell.z == other_cell.z -1 and cell.x == other_cell.x:
				dict_temp[coord.RIGHT] = other_cell
			elif cell.z == other_cell.z +1 and cell.x == other_cell.x:
				dict_temp[coord.LEFT] = other_cell
		dict_cell[cell] = dict_temp
		
func get_dict_neighbours():
	return dict_cell
