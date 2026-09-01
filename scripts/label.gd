extends Label

func set_default() : 
	set_tooltip("")
	set_texte("")
	set_color(Color(0.0, 0.0, 0.0, 0.0))
	
func set_color(color):
	var style = get_theme_stylebox("normal").duplicate() as StyleBoxFlat
	style.bg_color = color
	add_theme_stylebox_override("normal", style)
	
func set_tooltip(texte) : 
	tooltip_text = texte
	
func set_texte(texte) : 
	text = texte
	if texte == "B" : 
		add_theme_color_override("font_color",Color())
	elif texte == "F" : 
		add_theme_color_override("font_color",Color(1.0, 1.0, 0.0, 1.0))
	else : 
		add_theme_color_override("font_color",Color(1.0, 1.0, 1.0, 1.0))
		
