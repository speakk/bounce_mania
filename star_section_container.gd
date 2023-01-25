extends PanelContainer

var star_names = ["Bronze", "Silver", "Gold"]

func set_star_level_requirements(requirements):
	for i in range(%Stars.get_child_count()):
		var star_child = %Stars.get_child(i)
		star_child.get_node("TimeLabel").text = "%ss" % requirements[i]

func set_star_level_reached(level):
	print("level ", level)
	
	var icon_texture = %Stars.get_child(level).get_node("Icon").texture
	
	for child in %Stars.get_children():
		child.get_node("Icon").modulate = Color(1, 1, 1, 0.1)
		child.get_node("Icon").texture = icon_texture
		
		if level != null:
			var index = %Stars.get_children().find(child)
			if index <= level:
				print("Modulating level", index)
				child.get_node("Icon").modulate = Color(1, 1, 1, 1)

	if level != null and level > 0:
		%ReachedLabel.text = "You reached: %s!" % star_names[level]
	else:
		%ReachedLabel.text = "You didn't reach a star"
