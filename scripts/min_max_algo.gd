extends Node
class_name MinMaxAlgo

@export var gamelogic : Node

var max_depth
var max_time
var player

var init_time
var depth

var tree
var current_node


func _ready() -> void:
	var a = test_build(2,0,1)
	print(a)

func test_build(number_of_child,depth,depth_max):
	var tot = {"val" = depth,"next" = []}
	if depth == depth_max:
		return {"val" = depth}
	for i in range(0,number_of_child):
		tot["next"].append(test_build(number_of_child,depth+1,depth_max))

	return tot

func set_param(_max_depth, _max_time, _player):
	self.max_depth = _max_depth
	self.max_time = _max_time
	self.player = _player
	
	self.init_time = Time.get_ticks_msec()

func build_tree(_dict_total, _degree, _player) -> Dictionary:
	#récursivement, c'est mieux
	var next_moves = gamelogic.compute_next_moves(_dict_total, _player)
	var node = {"dict_total" = _dict_total, "next_moves" = [], "val" = eval(_dict_total)}
	if _degree == 0:
		return {"dict_total" = _dict_total, "next_moves" = null, "val" = eval(_dict_total)}
	for move in next_moves:
		var dict = guessing_dict(move,_dict_total,_player)
		node["next_moves"].append(build_tree(dict, _degree-1, gamelogic.get_ennemy_player(_player)))
	return node
	
	
func guessing_dict(move,_dict_total,_player):
	pass
	
func is_over_time():
	return Time.get_ticks_msec() - init_time > max_time

func is_over_depth():
	return depth > max_depth
	
func eval(dict_total):
	return 1.0/float(len(dict_total.keys()))
	
	
