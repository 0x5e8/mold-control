extends Camera3D

@export var mouse_cast_range: float = 100

func mouse_cast() -> Dictionary:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = self.project_ray_origin(mouse_pos)
	ray_query.to = ray_query.from + self.project_ray_normal(mouse_pos) * mouse_cast_range
	ray_query.collide_with_areas = true
	
	return get_world_3d().direct_space_state.intersect_ray(ray_query)
