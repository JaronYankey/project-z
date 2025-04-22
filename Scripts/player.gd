extends CharacterBody2D

# Player movement values
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0

# Dashing 
@export var dashing_speed: float = 600.0
@export var dash_time: float = .5

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
	#camera.process_callback = 0 I changed this in the inspector. But I think this is 
	# what it looks like in code.

func _process(delta):
	play_animation()
	
func _physics_process(delta):
	var input = Vector2.ZERO
	
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
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
		terry.is_pulled = !terry.is_pulled
		pulling_terry = !pulling_terry
	
	if pulling_terry:
		max_speed = 27
		acceleration = 20
		friction = 1700
	elif pulling_terry == false:
		max_speed = 200
		acceleration = 800
		friction = 600
	
	move_and_slide()

func play_animation():
	if velocity != Vector2.ZERO:
		animations.play("walk")
	else:
		animations.play("idle")
		
	if Input.is_action_pressed("left"):
		animations.flip_h = false
	if Input.is_action_pressed("right"):
		animations.flip_h = true
	
		
func set_power(power: String):
	if power == "nimble":
		ability = dash # No parentheses on the call to "dash()" because its assignment, not a call to dash()

func dash(delta):
	if not power_ready:
		power_ready = true
		audio_player.stream = dash_sound
		audio_player.play() 
		velocity *= dashing_speed / max_speed
		move_and_slide()
		await get_tree().create_timer(dash_time).timeout
		power_ready = false
		velocity *= Vector2.ZERO
	
func riot_charge():
	pass
	
func bullet_frenzy():
	pass


func _on_area_2d_spawn_inhibitor_body_entered(body):
	if body.is_in_group("terry"):
		near_terry = true
		terry = body
	
	# Rough "melee" kill mechanic
	if body.is_in_group("basic_zombie") and power_ready:
		body.hit(200)
		audio_player.stream = slice_sound
		audio_player.play()
		
		


func _on_area_2d_spawn_inhibitor_body_exited(body):
	if body.is_in_group("terry"):
		near_terry = false
		
