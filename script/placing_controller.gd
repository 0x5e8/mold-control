extends Node

@export var building_container: Node

var placing_building: Building = null

var lab: Resource = preload("res://building/lab/lab.tscn")

func _input(event: InputEvent) -> void:
	if Globals.current_mode != Globals.Mode.PLACING:
		if placing_building:
			placing_building.queue_free()
			placing_building = null
		return
	if event is InputEventMouseMotion:
		if not placing_building:
			placing_building = lab.instantiate()
			placing_building.set_opacity(0.1)
			building_container.add_child(placing_building)
		
		var raycast: Dictionary = %camera.mouse_cast()
		if not raycast.is_empty():
			placing_building.global_position = raycast.position
			placing_building.snap_to_grid()
	if event is InputEventMouseButton and placing_building:
		if event.button_index == MOUSE_BUTTON_LEFT:
			placing_building.disable_opacity()
			placing_building = null
