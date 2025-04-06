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
	
	# TODO: Get gun to flip to correct directions 
	
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
	$ShootingSound.play()
	await get_tree().create_timer(0.4).timeout
	weapon_animation.stop()
	#$ReloadSound.play() # Shotgun type of cocking sound. Don't like this for that purpose.
	# Shotgun cocking should sound heavy and powerful along with the weapon feeling strong.
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
