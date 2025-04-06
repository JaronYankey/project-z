extends CharacterBody2D

@export var speed: float = 50
@onready var animation = $AnimatedSprite2D
var player: Node2D = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta):
	if player: # Ensures we dont have a null value
		# Once zombie has closed the distance, it latches to the player. This may be 
		# from normalized(), as it mentions possible issues if the input Vector is near zero.
		# Right now you can kill the zombie and its not a big deal that it latches.
		# TODO: But I need to eventually address this if time permits.
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		animation.play()
