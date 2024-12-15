extends Node

var draggable: bool = false
@onready var target_pos: Vector3 = %camera.global_position

func reset_target_pos():
	target_pos = %camera.global_position

func _ready() -> void:
	%camera.camera_stopped.connect(reset_target_pos)

func _physics_process(delta: float) -> void:
	%camera.global_position = lerp(%camera.global_position, target_pos, 1 - pow(0.1, delta * 5.0))
	target_pos = vpclamp(target_pos, %platform.position, %platform.position, Globals.camera_limit_xyz_cubed)

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
#desperation
func vpclamp(v: Vector3,v_min: Vector3,v_max: Vector3, offset: float = 0) -> Vector3:
	v.x = clamp(v.x, v_min.x - offset, v_max.x + offset)
	v.y = clamp(v.y, v_min.y - offset, v_max.y + offset)
	v.z = clamp(v.z, v_min.z - offset, v_max.z + offset)
	return Vector3(v.x, v.y, v.z)
