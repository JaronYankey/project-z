extends CharacterBody2D

enum CAT_STATES {content, scared, hungry, happy}

@export var pull_force = 500.0

@onready var terry_collison = $TerryCollisionShape
@onready var audio_player = $AudioStreamPlayer2D
@onready var health_bar = $ProgressBar
@onready var leash = $LeashLine
@onready var idle_timer = $IdleTimer
@onready var moving_timer = $MovingTimer

var is_pulled = false
var leashed = false
var player_ref: Node2D = null
var colliding_objects: Array = []
var vec_dirs: Array = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

var walking = false
var idle = true
var walk_idle_toggle = true

func _ready():
	player_ref = get_tree().get_first_node_in_group("player")
	health_bar.value = 100


func _process(delta):
	check_collision_type(colliding_objects)


func _physics_process(delta):
	
	move(delta)
	if is_pulled and player_ref:
		var direction = (player_ref.global_position - global_position).normalized()
		var pull_strength = 200  # Lower = heavier
		velocity = direction * pull_strength
		move_and_slide()
		
		# Get the cat FEELING like a cat!:D
		
		
	if leashed and player_ref:
		# Leash visual
		leash.clear_points()
		leash.points = [
			leash.to_local(global_position),
			leash.to_local(player_ref.global_position)
		]


func move(delta):
	var state = cat_state()
	var direction
	var speed 
	
	if walking == false and idle == true and !walk_idle_toggle:
		direction = Vector2.ZERO
		speed = 1 # should equate to no movement.
		idle_timer.wait_time = randi_range(2, 4)
		idle = false
		idle_timer.start()
	# TODO: Not working 
	if state == CAT_STATES.content and idle == true:
		direction = vec_dirs.pick_random()
		speed = 300
		moving_timer.wait_time = randi_range(2, 4)
		idle = false
		walking = true
		walk_idle_toggle = !walk_idle_toggle # Brain not working, hopefilly toggles 
		moving_timer.start()
		
	if direction:
		velocity = direction * speed
		move_and_slide()


# What is the cat's current motive?
func cat_state():
	
	if is_content(): # Criteria for "Content" has been met
		return CAT_STATES.content


func is_content():
	# If criteria for being content is met
	return true
	
func check_collision_type(objects: Array):
	#TODO: This works. But it calls is every frame so terry dies SUPER quick. 
	# NOTE: reducing the damage output to something very small seems okay. 
	# it gives a nice slower steady health depletion. 
	if objects.is_empty():
		return
	var length = objects.size()
	for i in range(length):
		if objects[i].is_in_group("basic_zombie"):
			# TODO: FIX: Audio re-triggers everyframe so you never hear it play. 
			audio_player.play()
			health_bar.value = health_bar.value - 0.1

func remove_from_collision_area_array(object: Node):
	colliding_objects.erase(object)


func _on_terry_body_zone_body_entered(body):
	colliding_objects.append(body)
	


func _on_terry_body_zone_body_exited(body):
	call_deferred("remove_from_collision_area_array", body)


func _on_moving_timer_timeout():
	idle = true
	walking = false
	# direction global to change to Vector2.ZERO?


func _on_idle_timer_timeout():
	idle = true
