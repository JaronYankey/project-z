extends Area2D



func _on_body_entered(body):
	if body.is_in_group("player"):
		# Modify player stats/set player class abilites.
		body.speed = 400 # The speed boost is just for testing right now.
		body.set_power("nimble")
		queue_free()
