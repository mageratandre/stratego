extends Area3D
var cell
var type

@export var icon : Decal
@export var tower : MeshInstance3D

func set_icon(type):
	
	if(type == PieceTypes.types.BANNER):
		icon.texture_albedo = load("res://assets/icon_pieces/banner.png")
	if(type == PieceTypes.types.BOMB):
		icon.texture_albedo = load("res://assets/icon_pieces/bomb.png")
	if(type == PieceTypes.types.CAPTAIN):
		icon.texture_albedo = load("res://assets/icon_pieces/captain.png")
	if(type == PieceTypes.types.COLONEL):
		icon.texture_albedo = load("res://assets/icon_pieces/colonel.png")
	if(type == PieceTypes.types.GENERAL):
		icon.texture_albedo = load("res://assets/icon_pieces/general.png")
	if(type == PieceTypes.types.LIEUTENANT):
		icon.texture_albedo = load("res://assets/icon_pieces/lieutenant.png")
	if(type == PieceTypes.types.MAJOR):
		icon.texture_albedo = load("res://assets/icon_pieces/major.png")
	if(type == PieceTypes.types.MARSHAL):
		icon.texture_albedo = load("res://assets/icon_pieces/marshal.png")
	if(type == PieceTypes.types.MINER):
		icon.texture_albedo = load("res://assets/icon_pieces/miner.png")
	if(type == PieceTypes.types.SCOUT):
		icon.texture_albedo = load("res://assets/icon_pieces/scout.png")
	if(type == PieceTypes.types.SERGEANT):
		icon.texture_albedo = load("res://assets/icon_pieces/sergeant.png")
	if(type == PieceTypes.types.SPY):
		icon.texture_albedo = load("res://assets/icon_pieces/spy.png")
		
func set_cell(cell):
	self.cell = cell

func get_cell():
	return cell
	
func set_color(color):
	var mat = tower.get_active_material(0).duplicate() as StandardMaterial3D
	var blue = Color(0.283, 0.604, 0.95, 1.0)
	var red = Color(0.95, 0.309, 0.258, 1.0)

	if color == PieceTypes.color.BLUE : 
		mat.albedo_color = blue
	else : 
		mat.albedo_color = red
	tower.set_surface_override_material(0,mat)
	
func set_rot(rot):
	rotation_degrees.y = rot
	
func remove():
	queue_free()
	
