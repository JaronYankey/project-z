extends Area2D



func _on_body_entered(body):
	if body.is_in_group("player"):
		# Modify player stats or activate stats.
		body.speed = 400
		body.set_power("nimble")
		queue_free()
