extends Node2D

@export var bullet_scene: PackedScene  # Assign bullet scene in the editor
@export var fire_rate: float = .3  # Time between shots
@export var bullet_speed: float = 800  # Adjust as needed

var can_shoot: bool = true

@onready var muzzle = $Muzzle

func _process(delta):
	look_at(get_global_mouse_position())  # Rotate toward the mouse
	
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	if not bullet_scene: return

	can_shoot = false
	var bullet = bullet_scene.instantiate()
	
	bullet.global_position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation  # Make sure bullet flies in the correct direction
	bullet.set_velocity(bullet_speed)
	get_tree().current_scene.add_child(bullet)
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
