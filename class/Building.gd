@tool
class_name Building
extends StaticBody3D

enum BuildingType {
	DECOR,
	LAB,
}

@export var building_type: BuildingType
@export var dimension: Vector3i = Vector3i(1, 1, 1):
	set(val):
		dimension = val
		update_collision_shape()

enum {
	MISSING_COLLISION_SHAPE
}
var editor_errors = {
	MISSING_COLLISION_SHAPE: false
}

func _ready() -> void:
	self.scale = Vector3(1, 1, 1)
	update_collision_shape()

func update_collision_shape():
	# avoid running this function as a class (idk what to call it)
	if not self.name:
		return
	
	if not $collision_shape:
		return
	
	if not $collision_shape.shape or not $collision_shape.shape is BoxShape3D:
		$collision_shape.shape = BoxShape3D.new()
	
	$collision_shape.shape.size = dimension
	$collision_shape.position = dimension / 2.0
	$collision_shape.position.y -= 0.5

func snap_to_grid() -> void:
	self.global_position = self.global_position.snapped(Vector3i(1, 1, 1))
	self.global_rotation = self.global_rotation.snapped(Vector3(PI/2, PI/2, PI/2))

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		snap_to_grid()
		
		editor_errors[MISSING_COLLISION_SHAPE] = not $collision_shape or not $collision_shape is CollisionShape3D
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var errors = []
	
	if editor_errors[MISSING_COLLISION_SHAPE]:
		errors.append("child \"collision_shape\" of type CollisionShape3D not found, consider adding one")
	
	return errors