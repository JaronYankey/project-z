extends RigidBody2D

@export var pull_force = 500.0
@export var friction = 400.0

var is_pulled = false
var player_ref: Node2D = null
var direction: Vector2

func _ready():
	player_ref = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	
	# I do not know if this does anything...
	if (direction - global_position) == Vector2.ONE:
		apply_force(Vector2.ZERO * friction)
		
	if is_pulled and player_ref:
		direction = (player_ref.global_position - global_position).normalized()
		apply_force(direction * pull_force)
		
		# Leash visual
		$Line2D.clear_points()
		$Line2D.add_point(position)
		$Line2D.add_point(player_ref.position)
