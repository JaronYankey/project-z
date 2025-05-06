extends CharacterBody2D

@export var pull_force = 500.0

@onready var terry_collison = $TerryCollisionShape
@onready var audio_player = $AudioStreamPlayer2D
@onready var health_bar = $ProgressBar
@onready var leash = $LeashLine

var is_pulled = false
var leashed = false
var player_ref: Node2D = null
var colliding_objects: Array = []

func _ready():
	player_ref = get_tree().get_first_node_in_group("player")
	health_bar.value = 100


func _process(delta):
	check_collision_type(colliding_objects)


func _physics_process(delta):
	
	# TODO FIX TERRY MOVEMENT. I CHANGED FROM A PHYSICS BODY2D TO A CHARACTERBODY2D
	# MOVEMENT IS BROKEN NOW, BUT IN THE LONG TERM SHOULD SERVE BETTER FOR HIS AI MOVEMENT.
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
