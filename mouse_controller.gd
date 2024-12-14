extends Node

var hold = false
var draggable = false
@export var speed = 1
var c_speed = speed
@export var cam_weight = 0.2
var target: Vector3

func _ready() -> void:
	target = %camera.global_position
	

func _physics_process(delta: float) -> void:

	%camera.global_position = lerp(%camera.global_position,target,cam_weight)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed:
			pass
		match event.button_index:
			MOUSE_BUTTON_LEFT: 
				hold = !hold
			MOUSE_BUTTON_RIGHT:
				pass
			MOUSE_BUTTON_MIDDLE:
				draggable = !draggable
			MOUSE_BUTTON_WHEEL_DOWN:
				if %camera.fov < 75:
					%camera.fov += 5
					speed += 0.05
				else:
					%camera.fov = 75
			MOUSE_BUTTON_WHEEL_UP:
				if %camera.fov > 5:
					%camera.fov -= 5
					speed -= 0.05
				else:
					%camera.fov = 5

	if event is InputEventMouseMotion and (hold and draggable):
			target -= mouse_movement(event)
			
func mouse_movement(event):
	
	var mouse_dir = event.relative.normalized()
	return clamp(speed,0.2,c_speed)*((%camera.global_basis.x * mouse_dir.x) - (%camera.basis.y * mouse_dir.y))
