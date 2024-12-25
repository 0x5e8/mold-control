extends Node


@export var building_container: Node

var placing_building: Building = null
var placable: bool

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
			placing_building.enable_preview_mode()
			building_container.add_child(placing_building)
		
		var raycast: Dictionary = %Camera.mouse_cast()
		if not raycast.is_empty():
			raycast.position.y = 0 # only place in plane
			placing_building.global_position = raycast.position
			placing_building.snap_to_grid()
			
			if placing_building.has_overlapping_areas():
				placable = false
				placing_building.preview_mode_not_placable()
			else:
				placable = true
				placing_building.preview_mode_placable()
			
	if event is InputEventMouseButton and placing_building:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and placable:
			print("building placed at", placing_building.position)
			placing_building.disable_preview_mode()
			placing_building = null
	
	if event is InputEventMouseButton and placing_building and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_DOWN:
				placing_building.rotation.y += PI/2
			MOUSE_BUTTON_WHEEL_UP:
				placing_building.rotation.y -= PI/2
		placing_building.snap_to_grid()
