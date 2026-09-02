extends Control

@export var container : GridContainer
var cells = []
var bounds = [10,10,-10,-10]   #x_down, z_down, x_up, z_up

enum drawing_mode {ALL,ONLY_SHOWN,RED_SHOWN,BLUE_SHOWN}
var current_mode
var last_dict

func _ready() -> void:
	current_mode = drawing_mode.ALL

func set_drawing_mode(mode):
	current_mode = mode
	print(mode)
	draw_pieces(last_dict)

func _process(delta: float) -> void:
	container.size.x = container.size.y
	if Input.is_action_just_pressed("shown_all"):
		set_drawing_mode(drawing_mode.ALL)
	if Input.is_action_just_pressed("show_known"):
		set_drawing_mode(drawing_mode.ONLY_SHOWN)
	if Input.is_action_just_pressed("show_blue"):
		set_drawing_mode(drawing_mode.BLUE_SHOWN)
	if Input.is_action_just_pressed("show_red"):
		set_drawing_mode(drawing_mode.RED_SHOWN)
		
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
			
			var scene = load("res://scenes/visual_scenes/label.tscn")
			var instance = scene.instantiate() as Label
			
			if Vector3(float(bounds[0]+i),float(0),float(bounds[3]-j)) not in cells:
				
				var new_style = instance.get_theme_stylebox("normal").duplicate() as StyleBoxFlat
				new_style.set_border_width(SIDE_TOP,0)
				new_style.set_border_width(SIDE_BOTTOM,0)
				new_style.set_border_width(SIDE_LEFT,0)
				new_style.set_border_width(SIDE_RIGHT,0)
				instance.add_theme_stylebox_override("normal", new_style)
				#instance.add_theme_stylebox_override()
				
			container.add_child(instance)
			
func draw_pieces(dict_placement):
	print(dict_placement)
	last_dict = dict_placement
	var keys = dict_placement.keys()
	for cell in cells:
		var number = (bounds[3]-cell.z)+(cell.x-bounds[0])*(bounds[3]-bounds[1]+1)
		var panel = container.get_child(number) as Label
		if cell in keys : 
			panel.set_color(set_color_loc(dict_placement[cell][1]))

			var str = get_name_piece(dict_placement[cell][0])
			var revealed  = dict_placement[cell][2]
			var color = dict_placement[cell][1]
			
			set_text_and_tooltip(panel, str,color,revealed)
		else : 
			panel.set_default()
			
func set_text_and_tooltip(panel, str,color,revealed) : 
	if current_mode == drawing_mode.ALL:
		panel.set_tooltip(str[0])
		panel.set_texte(str[1])
	elif current_mode == drawing_mode.ONLY_SHOWN : 
		if revealed == 1:
			panel.set_tooltip(str[0])
			panel.set_texte(str[1])
		else : 
			panel.set_tooltip("")
			panel.set_texte("")
	elif current_mode == drawing_mode.RED_SHOWN : 
		if color == PieceTypes.color.RED or revealed == 1 : 
			panel.set_tooltip(str[0])
			panel.set_texte(str[1])
		else : 
			panel.set_tooltip("")
			panel.set_texte("")
	elif current_mode == drawing_mode.BLUE_SHOWN : 
			if color == PieceTypes.color.BLUE or revealed == 1 : 
				panel.set_tooltip(str[0])
				panel.set_texte(str[1])
			else : 
				panel.set_tooltip("")
				panel.set_texte("")
				
func get_name_piece(piece_int) :
	
	if piece_int == PieceTypes.types.MARSHAL:
		return ["Marshal (10)","9"]
	elif piece_int == PieceTypes.types.BANNER:
		return ["Banner (0)","F"]
	elif piece_int == PieceTypes.types.BOMB:
		return ["Bomb (11)","B"]
	elif piece_int == PieceTypes.types.CAPTAIN:
		return ["Captain (6)","5"]
	elif piece_int == PieceTypes.types.COLONEL:
		return ["Colonel (8)","7"]
	elif piece_int == PieceTypes.types.GENERAL:
		return ["General (9)","8"]
	elif piece_int == PieceTypes.types.LIEUTENANT:
		return ["Lieutenant (5)","4"]
	elif piece_int == PieceTypes.types.MAJOR:
		return ["Major (7)","6"]
	elif piece_int == PieceTypes.types.MINER:
		return ["Miner (3)","2"]
	elif piece_int == PieceTypes.types.SCOUT:
		return ["Scout (2)","1"]
	elif piece_int == PieceTypes.types.SPY:
		return ["Spy (1)","0"]
	else:
		return ["Sergeant (4)","3"]
	
		
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
	
func set_color_loc(color)->Color:
	if color == PieceTypes.color.RED:
		return Color(0.862, 0.306, 0.325, 1.0)
	else : 
		return Color(0.0, 0.539, 1.0, 1.0)
		
	
		
func set_color_shown(piece,color)-> Color:
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
		return Color.GREEN
	
