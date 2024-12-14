extends Node

func _process(delta: float) -> void:
	var mousecast = %camera.mouse_cast()
	if len(mousecast.keys()):
		$point.position = mousecast["position"]
