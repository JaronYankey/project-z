extends RigidBody2D

@export var pull_force = 500.0
@export var friction = 400.0

var is_pulled = false
var player_ref: Node2D = null
var direction: Vector2

@onready var terry_collison = $CollisionShape2D
@onready var audio_player = $AudioStreamPlayer2D
@onready var health_bar = $ProgressBar

func _ready():
	player_ref = get_tree().get_first_node_in_group("player")
	health_bar.value = 100


func _process(delta):
	pass


func _physics_process(delta):
	
	# I do not know if this does anything...
	if (direction - global_position) == Vector2.ONE:
		apply_force(Vector2.ZERO * friction)
		
	if is_pulled and player_ref:
		direction = (player_ref.global_position - global_position).normalized()
		apply_force(direction * pull_force)
		
		# Leash visual
		$Line2D.clear_points()
		$Line2D.points = [
			$Line2D.to_local(global_position),
			$Line2D.to_local(player_ref.global_position)
		]


func _on_terry_body_zone_body_entered(body):
	if body.is_in_group("basic_zombie"):
		# Zombies currently trigger only once when they enter Terry's Area2D
		#TODO: Change to every 2 seconds (or something like that) zombies deal damage
		# while still in Terry's area2D.
		audio_player.play()
		health_bar.value = health_bar.value - 10
