extends Control

@export var container : GridContainer
var cells = []
var bounds = [10,10,-10,-10]   #x_down, z_down, x_up, z_up

func _process(delta: float) -> void:
	container.size.x = container.size.y
	
func add_cell(cell):
	cells.append(cell)
	
func draw_cells():
	for i in range(0,len(cells)):
		if (cells[i].x < bounds[0]):
			bounds[0] = cells[i].x
		if (cells[i].z < bounds[1]):
			bounds[1] = cells[i].z
		if (cells[i].x > bounds[2]):
			bounds[2] = cells[i].x
		if (cells[i].z > bounds[3]):
			bounds[3] = cells[i].z
	var number_z = bounds[3]-bounds[1] +1
	var number_x = bounds[2]-bounds[0] +1
	
	container.columns =  number_z             #columns en z et ligne en x
	for i in range(0,number_x):
		for j in range(0, number_z):
			
			var scene = load("res://scenes/panel.tscn")
			var instance = scene.instantiate() as Panel
			
			if Vector3(float(bounds[0]+i),float(0),float(bounds[3]-j)) not in cells:
				
				var new_style = instance.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
				new_style.set_border_width(SIDE_TOP,0)
				new_style.set_border_width(SIDE_BOTTOM,0)
				new_style.set_border_width(SIDE_LEFT,0)
				new_style.set_border_width(SIDE_RIGHT,0)
				instance.add_theme_stylebox_override("panel", new_style)
				#instance.add_theme_stylebox_override()
				
			container.add_child(instance)
			
func draw_pieces(dict_placement):
	# le dict est bon
	var keys = dict_placement.keys()
	for cell in cells:
		var number = (bounds[3]-cell.z)+(cell.x-bounds[0])*(bounds[3]-bounds[1]+1)
		var panel = container.get_child(number) as Panel
		var style = panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
		if cell not in keys : 
			style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
		else : 
			style.bg_color = set_color(dict_placement[cell][0],dict_placement[cell][1])
		panel.add_theme_stylebox_override("panel", style)
		
func get_gradient_double(color1 : Color, color2 : Color, color3 : Color, intervals : int)->Array:
	var array1 = get_gradient_simple(color1,color2,intervals/2)
	var array2 = get_gradient_simple(color2,color3,intervals/2)
	array2.append(color3)
	array1.append_array((array2))
	return array1
	
func get_gradient_simple(color1 : Color, color2 : Color, intervals : int)-> Array:
	var colors = []
	var c1 = color1
	var c2 = color2
	var n = intervals
	for i in range(n):
		colors.append(Color(c1.r+(c2.r-c1.r)*i/n,c1.g+(c2.g-c1.g)*i/n,c1.b+(c2.b-c1.b)*i/n,1.0))
	return colors
	
func set_color(piece,color)->Color:
	var color_0 = Color(0.0, 0.0, 0.0, 1.0)
	var color_1
	if color == PieceTypes.color.BLUE : 
		color_1 =Color(0.0, 0.0, 1.0, 1.0)
	else : 
		color_1 = Color(1.0, 0.0, 0.0, 1.0)
	var color_2 = Color(1.0, 1.0, 1.0, 1.0)
	var gradient = get_gradient_double(color_0,color_1,color_2,11)
	
	if piece == PieceTypes.types.BANNER:
		return Color.GOLD
	elif piece == PieceTypes.types.BOMB:
		return gradient[0]
	elif piece == PieceTypes.types.MARSHAL:
		return gradient[1]
	elif piece == PieceTypes.types.GENERAL:
		return gradient[2]
	elif piece == PieceTypes.types.COLONEL:
		return gradient[3]
	elif piece == PieceTypes.types.MAJOR:
		return gradient[4]
	elif piece == PieceTypes.types.CAPTAIN:
		return gradient[5]
	elif piece == PieceTypes.types.LIEUTENANT:
		return gradient[6]
	elif piece == PieceTypes.types.SERGEANT:
		return gradient[7]
	elif piece == PieceTypes.types.MINER:
		return gradient[8]
	elif piece == PieceTypes.types.SCOUT:
		return gradient[9]
	elif piece == PieceTypes.types.SPY:
		return gradient[10]
	else : 
		return Color.RED
	
