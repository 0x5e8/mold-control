@tool
class_name Building
extends Node3D

func snap_to_grid() -> void:
	self.position = self.position.snapped(Vector3i(1, 1, 1))
	self.rotation = self.rotation.snapped(Vector3(PI/2, PI/2, PI/2))

var old_position: Vector3
var old_rotation: Vector3
func _physics_process(_delta: float) -> void:
	if old_position != self.position or old_rotation != self.rotation:
		snap_to_grid()
	
	old_position = self.position
	old_rotation = self.rotation
	
	self.scale = Vector3(1, 1, 1)
