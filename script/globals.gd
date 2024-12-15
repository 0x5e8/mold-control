extends Node

enum Mode {
	NORMAL,
	PLACING,
	SELECTING,
}

var mode_name = {
	Mode.NORMAL: "normal",
	Mode.PLACING: "placing",
	Mode.SELECTING: "selecting",
}

signal current_mode_changed
var current_mode: Mode:
	set(val):
		if current_mode != val:
			current_mode = val
			current_mode_changed.emit(val)

signal current_building_changed
var current_building: Building:
	set(val):
		if current_building != val:
			current_building = val
			current_building_changed.emit(val)
			
			if val:
				current_mode = Mode.SELECTING
			else:
				current_mode = Mode.NORMAL

var camera_limit_box: Vector3 = Vector3(50, 50, 50)
