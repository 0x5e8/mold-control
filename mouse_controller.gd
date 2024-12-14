extends Node

var draggable = false
var target_pos: Vector3

func _ready() -> void:
	target_pos = %camera.global_position

func _physics_process(delta: float) -> void:
	%camera.global_position = lerp(%camera.global_position, target_pos, 0.4)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_MIDDLE:
			draggable = event.pressed
	
	if event is InputEventMouseMotion and draggable:
		var mouse_dir = event.relative.normalized() / 2.0
		target_pos -= (%camera.global_basis.x * mouse_dir.x) - (%camera.basis.y * mouse_dir.y)
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_DOWN:
				target_pos += %camera.global_basis.z * 2
			MOUSE_BUTTON_WHEEL_UP:
				target_pos -= %camera.global_basis.z * 2
