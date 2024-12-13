extends Node

var draggable: bool = false
@onready var target_pos: Vector3 = %camera.global_position

func reset_target_pos():
	target_pos = %camera.global_position

func _ready() -> void:
	%camera.camera_stopped.connect(reset_target_pos)

func _physics_process(delta: float) -> void:
	%camera.global_position = lerp(%camera.global_position, target_pos, 1 - pow(0.1, delta * 5.0))
	target_pos = target_pos.clamp(
		%platform.position - Globals.camera_limit_box,
		%platform.position + Globals.camera_limit_box
	)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			draggable = event.pressed
	
	if event is InputEventMouseMotion and draggable:
		var mouse_dir = event.relative.normalized() / 2.0
		target_pos -= (%camera.global_basis.x * mouse_dir.x) - (%camera.basis.y * mouse_dir.y)
	
	if event is InputEventMouseButton and event.pressed and Globals.current_mode != Globals.Mode.PLACING:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_DOWN:
				target_pos += %camera.global_basis.z * 2
			MOUSE_BUTTON_WHEEL_UP:
				target_pos -= %camera.global_basis.z * 2
