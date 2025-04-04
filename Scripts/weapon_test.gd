extends Node2D

@export var bullet_scene: PackedScene  # Assign bullet scene in the editor
@export var fire_rate: float = .3  # Time between shots
@export var bullet_speed: float = 800  # Adjust as needed

var can_shoot: bool = true
var global_mouse_pos

@onready var muzzle = $Muzzle
@onready var weapon_animation = $WeaponAnimation

func _process(delta):
	global_mouse_pos = get_global_mouse_position()
	look_at(global_mouse_pos)  # Rotate toward the mouse
	
	# TODO: This does not work to flip sprite
	var mouse_local = get_local_mouse_position()
	if mouse_local.x < position.x:
		weapon_animation.flip_h = false
		weapon_animation.flip_v = true
	else:
		weapon_animation.flip_h = true
		weapon_animation.flip_v = false
	
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
	
	# TODO: Fixed this slightly. But need a better way to fine tune this.
	weapon_animation.play("fire")
	await get_tree().create_timer(0.4).timeout
	weapon_animation.stop()
	
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
