extends Area2D



func spawn(zombie_scene: PackedScene):
	var zombie = zombie_scene.instantiate()
	zombie.global_position = global_position
	
	# No need for rotation on the zombies yet. Maybe never.
	get_tree().current_scene.add_child(zombie)
	
