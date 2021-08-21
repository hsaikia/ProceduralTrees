extends Panel

func _input(event):
	if event.is_action_released("hide_panel"):
		if visible :
			hide()
		else:
			show()
