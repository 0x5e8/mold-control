extends Node


var draggable: bool = false

@onready var target_pos = %Camera.global_position as Vector3


func _ready() -> void:
	%Camera.camera_stopped.connect(reset_target_pos)


func _physics_process(delta: float) -> void:
	%Camera.global_position = lerp(%Camera.global_position, target_pos, 1 - pow(0.1, delta * 5.0))
	target_pos = target_pos.clamp(
		%Platform.position - Globals.camera_limit_box,
		%Platform.position + Globals.camera_limit_box
	)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			draggable = event.pressed
	
	if event is InputEventMouseMotion and draggable:
		var mouse_dir = event.relative.normalized() / 2.0
		target_pos -= (%Camera.global_basis.x * mouse_dir.x) - (%Camera.basis.y * mouse_dir.y)
	
	if event is InputEventMouseButton and event.pressed and Globals.current_mode != Globals.Mode.PLACING:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_DOWN:
				target_pos += %Camera.global_basis.z * 2
			MOUSE_BUTTON_WHEEL_UP:
				target_pos -= %Camera.global_basis.z * 2


func reset_target_pos():
	target_pos = %Camera.global_position
