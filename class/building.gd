@tool
class_name Building
extends Area3D


enum BuildingType {
	DECOR,
	LAB,
}

enum {
	MISSING_COLLISION_SHAPE
}

@export var building_type: BuildingType
@export var dimension: Vector3i = Vector3i(1, 1, 1):
	set(val):
		dimension = val
		update_collision_shape()
@export var geometry: GeometryInstance3D

var editor_errors = {
	MISSING_COLLISION_SHAPE: false
}
var preview_mode: bool = false

func _ready() -> void:
	self.scale = Vector3(1, 1, 1)
	update_collision_shape()


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		snap_to_grid()
		update_collision_shape()
		
		editor_errors[MISSING_COLLISION_SHAPE] = (
			not $CollisionShape
			or $CollisionShape is not CollisionShape3D
		)
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var errors = []
	
	if editor_errors[MISSING_COLLISION_SHAPE]:
		errors.append("child \"CollisionShape\" of type CollisionShape3D not found, consider adding one")
	
	return errors


func disable_preview_mode():
	assert(geometry, "an geometry instance must be given")
	
	geometry.material_override.transparency = BaseMaterial3D.Transparency.TRANSPARENCY_DISABLED
	geometry.material_override.albedo_color = Color(1, 1, 1)
	preview_mode = false


func enable_preview_mode():
	assert(geometry, "an geometry instance must be given")
	
	if not geometry.material_override:
		geometry.material_override = StandardMaterial3D.new()
	
	geometry.material_override.transparency = BaseMaterial3D.Transparency.TRANSPARENCY_ALPHA
	geometry.material_override.albedo_color.a = 0.1
	
	preview_mode = true


func preview_mode_placable():
	if not preview_mode:
		return
	assert(geometry, "an geometry instance must be given")
	geometry.material_override.albedo_color = Color(0, 1, 0)


func preview_mode_not_placable():
	if not preview_mode:
		return
	
	assert(geometry, "an geometry instance must be given")
	geometry.material_override.albedo_color = Color(1, 0, 0)


func update_collision_shape():
	# avoid running this function as a class (idk what to call it)
	if not self.name:
		return
	
	if not $CollisionShape.shape or not $CollisionShape.shape is BoxShape3D:
		$CollisionShape.shape = BoxShape3D.new()
	
	$CollisionShape.shape.size = dimension * 0.99 # shrink it a bit to avoid stupid collision check
	$CollisionShape.position = dimension / 2.0
	$CollisionShape.position.y -= 0.5


func snap_to_grid() -> void:
	self.global_position = self.global_position.snapped(Vector3i(1, 1, 1))
	self.global_rotation = self.global_rotation.snapped(Vector3(PI/2, PI/2, PI/2))
