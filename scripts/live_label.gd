extends Label

var period = 1
var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time+=delta
	var val = sin(2*PI*time/period)
	if val >=0:
		visible = true
	else : 
		visible = false
	
