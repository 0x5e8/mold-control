extends Node

var draggable = false

@export var cam_weight = 0.2
var target_pos: Vector3

func _ready() -> void:
	target_pos = %camera.global_position

func _physics_process(delta: float) -> void:
	%camera.global_position = lerp(%camera.global_position, target_pos, cam_weight)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_MIDDLE:
			draggable = event.pressed
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT: 
				pass
			MOUSE_BUTTON_RIGHT:
				pass
			MOUSE_BUTTON_MIDDLE:
				draggable = !draggable
			MOUSE_BUTTON_WHEEL_DOWN:
				if %camera.fov < 75:
					%camera.fov += 5
				else:
					%camera.fov = 75
			MOUSE_BUTTON_WHEEL_UP:
				if %camera.fov > 5:
					%camera.fov -= 5
				else:
					%camera.fov = 5
	
	if event is InputEventMouseMotion and draggable:
		target_pos -= mouse_movement(event)
	
func mouse_movement(event):
	var mouse_dir = event.relative.normalized() / 3.0
	return (%camera.global_basis.x * mouse_dir.x) - (%camera.basis.y * mouse_dir.y)
