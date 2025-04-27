extends CharacterBody2D

# Player movement values
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0

# Dashing 
@export var dashing_speed: float = 600.0
@export var dash_time: float = 1.0

# These don't work how I thought
@export var slice_sound : AudioStream
@export var dash_sound : AudioStream


@onready var camera = $Camera2D
@onready var animations = $AnimatedSprite2D
@onready var audio_player = $AudioStreamPlayer2D

var terry: Node2D = null
var pulling_terry = false
var terry_leashed = false
var near_terry = false
var power_ready: bool = false # Will be used to moderate ability use.
var ability


func _ready():
	# For now we allow smoothing, adds some juice. 
	camera.position_smoothing_enabled = true;

func _process(delta):
	play_animation()
	
func _physics_process(delta):
	var input = Vector2.ZERO
	
	
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	input = input.normalized()
	
	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if Input.is_action_pressed("special_power"):
		# Must use .call() on the var ability to get the function to run.
		if ability:
			ability.call(delta) # Run the appropriate function for the power the player has.
		
	if Input.is_action_just_released("interact") and near_terry:
		terry_leashed = !terry_leashed
		terry.leashed = !terry.leashed
	
	move_and_slide()

func play_animation():
	if velocity != Vector2.ZERO or pulling_terry:
		animations.play("walk")
	else:
		animations.play("idle")
		
	if Input.is_action_pressed("left"):
		animations.flip_h = false
	if Input.is_action_pressed("right"):
		animations.flip_h = true
	
func change_player_speed():
	# There is no logical correlation between Terry's speed and your speed.
	# I have just been tweaking values. This cna work, but I lose a lot of time messing
	# with it. UPDATE: IF WE ONLY CHANGE TERRY'S MASS VALUE, WE CAN TWEAK IT EASY AND IT 
	# FEELS OKAY. 
	if pulling_terry:
		# 27 OG value
		max_speed = 27
		# 20 OG value 
		acceleration = 0
		# 1700 OG value
		friction = 1700
	elif pulling_terry == false:
		max_speed = 200
		acceleration = 800
		friction = 600


func set_power(power: String):
	if power == "nimble":
		ability = dash # No parentheses on the call to "dash()" because its assignment, not a call to dash()

func dash(delta):
	if not power_ready:
		power_ready = true
		# TODO FIX: audio can be repeated without restraint.
		audio_player.stream = dash_sound
		audio_player.play() 
		velocity *= dashing_speed / max_speed
		move_and_slide()
		await get_tree().create_timer(dash_time).timeout
		power_ready = false
		# TODO: this causes a stutter step if its here, but allows the player to build
		# insane speed/momentum if its not. Need another way to handle this.
		velocity *= Vector2.ZERO


func _on_area_2d_spawn_inhibitor_body_entered(body):
	if body.is_in_group("terry"):
		# init terry and clip his leash on. 
		near_terry = true
		# INFO Must be close to terry to put his leash on him the first time.
		terry = body
	
	# Rough "melee" kill mechanic
	if body.is_in_group("basic_zombie") and power_ready:
		body.hit(200)
		audio_player.stream = slice_sound
		audio_player.play()
		
		


func _on_area_2d_spawn_inhibitor_body_exited(body):
	pass

# TODO FIX: I have too many semi-duplicate variables that are being used/checked. 
# This makes it harder to understand/follow what is going on in the code.
func _on_area_2d_spawn_inhibitor_area_entered(area):
	if terry and area.is_in_group("pull_radius"):
		# Might need "near terry" for leash mechanics in the future.
		#near_terry = true
		pulling_terry = false
		terry.is_pulled = false
		change_player_speed()
		


func _on_area_2d_spawn_inhibitor_area_exited(area):
	if terry and terry_leashed and area.is_in_group("pull_radius"):
		#near_terry = false
		terry.is_pulled = true
		pulling_terry = true
		change_player_speed()
		velocity *= Vector2.ZERO
