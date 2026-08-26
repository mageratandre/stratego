extends Control
@export var h_split_container: HSplitContainer 


@export var banner: TextureRect
@export var bomb : TextureRect
@export var spy : TextureRect
@export var marshal : TextureRect
@export var general : TextureRect
@export var colonel : TextureRect
@export var major : TextureRect
@export var captain : TextureRect
@export var lieutenant : TextureRect
@export var sergeant : TextureRect
@export var miner : TextureRect
@export var scout : TextureRect

var scroll_value = 0

signal spawn(type)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_numbers(max_per_unit):
	
	var tab = [banner,bomb,spy,marshal,general,colonel,major,captain,lieutenant,sergeant,miner,scout]
	
	for i in range(0,12):
		if (max_per_unit[i] != 0):
			tab[i].get_child(0).text = str(max_per_unit[i])
			tab[i].get_child(1).hide()
			tab[i].get_child(2).hide()
		else : 
			tab[i].get_child(0).text = ""
			tab[i].get_child(1).show()
			tab[i].get_child(2).show()
	

func _on_h_scroll_bar_value_changed(value: float) -> void:
	var delta = 0.0
	if(value-scroll_value)<0:
		delta = h_split_container.position.x-position.x
	if (value-scroll_value)>0:
		delta = h_split_container.position.x + h_split_container.size.x - size.x

	h_split_container.position.x -= (float(delta)/100.0)*value
	scroll_value = value


	
	
func _on_banner_button_button_down() -> void:
	spawn.emit(PieceTypes.types.BANNER)


func _on_bomb_button_button_down() -> void:
	spawn.emit(PieceTypes.types.BOMB)


func _on_spy_button_button_down() -> void:
	spawn.emit(PieceTypes.types.SPY)


func _on_marshal_button_button_down() -> void:
	spawn.emit(PieceTypes.types.MARSHAL)


func _on_general_button_button_down() -> void:
	spawn.emit(PieceTypes.types.GENERAL)


func _on_colonel_button_button_down() -> void:
	spawn.emit(PieceTypes.types.COLONEL)


func _on_major_button_button_down() -> void:
	spawn.emit(PieceTypes.types.MAJOR)


func _on_captain_button_button_down() -> void:
	spawn.emit(PieceTypes.types.CAPTAIN)


func _on_sergeant_button_button_down() -> void:
	spawn.emit(PieceTypes.types.SERGEANT)


func _on_miner_button_button_down() -> void:
	spawn.emit(PieceTypes.types.MINER)


func _on_scout_buttons_button_down() -> void:
	spawn.emit(PieceTypes.types.SCOUT)



func _on_lieutenant_button_button_down() -> void:
	spawn.emit(PieceTypes.types.LIEUTENANT)
