extends Control

@export var container : HSplitContainer

var number_max = [6,1,1,2,3,4,4,4,5,8,1]
var number_captured = [[0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_list()


func add_piece(piece):
	
	if piece[0] == PieceTypes.types.BOMB:
		number_captured[piece[1]][0] +=1
	elif piece[0] == PieceTypes.types.MARSHAL:
		number_captured[piece[1]][1] +=1
	elif piece[0] == PieceTypes.types.GENERAL:
		number_captured[piece[1]][2] +=1
	elif piece[0] == PieceTypes.types.COLONEL:
		number_captured[piece[1]][3] +=1
	elif piece[0] == PieceTypes.types.MAJOR:
		number_captured[piece[1]][4] +=1
	elif piece[0] == PieceTypes.types.CAPTAIN:
		number_captured[piece[1]][5] +=1
	elif piece[0] == PieceTypes.types.LIEUTENANT:
		number_captured[piece[1]][6] +=1
	elif piece[0] == PieceTypes.types.SERGEANT:
		number_captured[piece[1]][7] +=1
	elif piece[0] == PieceTypes.types.MINER:
		number_captured[piece[1]][8] +=1
	elif piece[0] == PieceTypes.types.SCOUT:
		number_captured[piece[1]][9] +=1
	elif piece[0] == PieceTypes.types.SPY:
		number_captured[piece[1]][10] +=1
	update_list()
	
func update_list():
	for player in range(len(number_captured)):
		for piece in range(len(number_captured[player])):
			container.get_child(player).get_child(piece).get_child(2).text = str(number_captured[player][piece])
			if number_captured[player][piece] == number_max[piece]:
				var rect = container.get_child(player).get_child(piece).get_child(1) as ColorRect
				rect.color.a = 0.75

	
