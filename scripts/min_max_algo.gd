extends Node
class_name MinMaxAlgo

var max_depth
var max_time

var init_time
var depth

var tree
var current_node

func set_param(_max_depth, _max_time):
	self.max_depth = _max_depth
	self.max_time = max_time
	self.init_time = Time.get_ticks_msec()

func build_node(val,move,possible_moves,dict_total):
	return {"val" = val, "move"=move, "next_moves" = possible_moves, "dict_total" = dict_total}

func is_over():
	return Time.get_ticks_msec() - init_time >max_time or depth < max_depth
	
func is_root(node):
	return node["move"] == null
