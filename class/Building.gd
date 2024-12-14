@tool
class_name Building
extends Node3D

func _ready() -> void:
	self.scale = Vector3(1, 1, 1)

func snap_to_grid() -> void:
	self.position = self.position.snapped(Vector3i(1, 1, 1))
	self.rotation = self.rotation.snapped(Vector3(PI/2, PI/2, PI/2))

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		snap_to_grid()
		self.scale = Vector3(1, 1, 1)
	
