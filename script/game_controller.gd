extends Node


func _ready() -> void:
	%Gridline.hide()
	%PropPanel.hide()
	
	Globals.current_building_changed.connect(change_building)
	Globals.current_mode_changed.connect(change_mode)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		Globals.current_mode = Globals.Mode.NORMAL
	
	if Globals.current_mode != Globals.Mode.PLACING and Input.is_action_just_pressed("select"):
		var raycast = %Camera.mouse_cast()
		if not raycast.is_empty():
			if raycast.collider is Building:
				Globals.current_building = raycast.collider
			else:
				Globals.current_building = null
		else:
			Globals.current_building = null


func change_mode(mode):
	%ModeButton.text = Globals.mode_name[mode]
	
	match mode:
		Globals.Mode.NORMAL:
			%Gridline.hide()
			%PropPanel.hide()
		Globals.Mode.PLACING:
			%Gridline.show()
			%PropPanel.hide()
		Globals.Mode.SELECTING:
			%Gridline.hide()
			%PropPanel.show()


func change_building(building):
	if not building: return
	%PropName.text = building.name


func _on_modebutton_pressed() -> void:
	if Globals.current_mode == Globals.Mode.SELECTING:
		Globals.current_mode = Globals.Mode.NORMAL
	else:
		Globals.current_mode += 1
