extends Node3D

@export var control_ui : Control
@export var Spawner_3D : Node3D
@export var map : Node3D
@export var piece_translucent : Area3D
@export var minimap : Control
@export var datasaver : Node

@export var message_error : Control

var max_number_per_piece = [1,6,1,1,1,2,3,4,4,4,5,8]
var dict_placement = {}
var type_selected
var cell_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	control_ui.spawn.connect(set_type)
	update_numbers()
	for i in range(0,map.get_node("Container").get_child_count()):
		map.get_node("Container").get_child(i).entered_cell.connect(set_cell)
		map.get_node("Container").get_child(i).exited_cell.connect(quit_cell)
		
		minimap.add_cell(map.get_node("Container").get_child(i).get_cell())
	minimap.draw_cells()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("place_piece"):
		if(cell_selected != null and type_selected != null):
			place_piece()
	
func set_type(type):
	type_selected = type
	piece_translucent.set_icon(type)

func set_cell(cell):
	if(cell.x>0):
		cell_selected = cell
		piece_translucent.show()
		piece_translucent.position.x = map.get_global(cell).x
		piece_translucent.position.z = map.get_global(cell).z
	
func quit_cell(cell):
	if(cell.x>0):
		cell_selected = null
		piece_translucent.hide()
	
func update_numbers():
	control_ui.update_numbers(max_number_per_piece)
	
func place_piece():
	
	if(dict_placement.has(cell_selected)) :   #si la case est occupée
		var old_type = dict_placement[cell_selected][0]
		Spawner_3D.remove(cell_selected)
		max_number_per_piece[old_type] +=1
		dict_placement.erase(cell_selected)
		
	else : 
		
		if(max_number_per_piece[type_selected]>0):  #s'il en reste
			dict_placement[cell_selected] = [type_selected, PieceTypes.color.BLUE]
			var pos = map.get_global(cell_selected)
			Spawner_3D.create(type_selected,pos.x,pos.z,cell_selected,PieceTypes.color.BLUE,false)
			max_number_per_piece[type_selected] -=1
				
		else : 
			message_error.message("Y en a plus")
			
	update_numbers()
	minimap.draw_pieces(dict_placement)
		
	

func _on_button_exit_scene_pressed() -> void:
	var all_empty = true
	for number in max_number_per_piece:
		if(number != 0):
			all_empty = false
	if all_empty:
		datasaver.save_dict("res://save_game.txt",dict_placement)
		message_error.message("Let's play !")
		change_scene()
	else : 
		message_error.message("Tu doit placer tt les pièces...")
		
	

func _on_button_load_data_pressed() -> void:
	# d'abord on supprime la grille qui existe
	var keys = dict_placement.keys()
	for key in keys: 
		cell_selected = key
		place_piece()
	#ensuite on charge le dictionnaire
	var dict_temp = datasaver.load_dict("res://save_game.txt")
	keys = dict_temp.keys()
	for key in keys:
		set_type(dict_temp[key][0])
		set_cell(key)
		place_piece()
		quit_cell(key)
	

func _on_button_show_grid_pressed() -> void:
	if minimap.visible : 
		minimap.hide()
	else:
		minimap.show()
		
func change_scene():
	var setup_scene = get_tree().current_scene
	var new_scene = load("res://scenes/PlayScene.tscn").instantiate()
	setup_scene.add_sibling(new_scene)
	setup_scene.queue_free()
	
