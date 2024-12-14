extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed: return
		
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				pass
			MOUSE_BUTTON_RIGHT:
				pass
			MOUSE_BUTTON_MIDDLE:
				pass
			MOUSE_BUTTON_WHEEL_DOWN:
				if %camera.fov < 75:
					%camera.fov += 5
				else:
					%camera.fov = 75
			MOUSE_BUTTON_WHEEL_UP:
				if %camera.fov > 5:
					%camera.fov -= 5
				else:
					%camera.fov = 5
