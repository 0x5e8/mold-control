extends Camera3D


signal camera_stopped

@export var mouse_cast_range: float = 100
@export var min_distance: float = 5.0:
	set(val):
		min_distance = val
		squared_min_distance = val * val

var squared_min_distance: float = 25.0
var last_collision_point: Vector3


func _physics_process(delta: float) -> void:
	var p = $Ray.get_collision_point()
	if p != last_collision_point:
		var dirvec: Vector3 = p - self.global_position
		if dirvec.length_squared() < squared_min_distance:
			#get back
			self.global_position += -dirvec.normalized() * (min_distance - dirvec.length())
			camera_stopped.emit()
	last_collision_point = p


func mouse_cast() -> Dictionary:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = self.project_ray_origin(mouse_pos)
	ray_query.to = ray_query.from + self.project_ray_normal(mouse_pos) * mouse_cast_range
	ray_query.collide_with_areas = true
	
	return get_world_3d().direct_space_state.intersect_ray(ray_query)
