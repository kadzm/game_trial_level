extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Camera2D.make_current() # switches to this camera

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		# switch back to player's camera
		body.get_node("Camera2D").make_current()
