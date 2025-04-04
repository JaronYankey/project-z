extends CharacterBody2D

# Player movement values
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0

# Dashing TEST
@export var dashing_speed: float = 400.0
@export var dash_time: float = 0.2

var power_ready: bool = false # Will be used to moderate ability use.
var ability
@onready var camera = $Camera2D

func _ready():
	# For now we allow smoothing, adds some juice. 
	camera.position_smoothing_enabled = true;
	#camera.process_callback = 0 I changed this in the inspector. But I think this is 
	# what it looks like in code.

	
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
			ability.call() # Run the appropriate function for the power the player has.
	
	move_and_slide()
	
func set_power(power: String):
	if power == "nimble":
		ability = dash # No parentheses because its assignment, not a call to dash()

func dash():
	if not power_ready:
		power_ready = true
		velocity *= dashing_speed / max_speed
		await get_tree().create_timer(dash_time).timeout
		power_ready = false
	
func riot_charge():
	pass
	
func bullet_frenzy():
	pass
