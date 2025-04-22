extends Area2D

@onready var audio_player = $AudioStreamPlayer2D
var speed: float = 800
var velocity: Vector2 

func _ready():
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	
func _process(delta):
	global_position += velocity * delta
	
func set_velocity(bullet_speed: float):
	speed = bullet_speed
	


func _on_body_entered(body):
	# Checks and calls methods according to what the bullet "hits"
	if body.is_in_group("basic_zombie"):
		body.hit(50)
		if randi() % 8 == 1:
			body.hit(100)
			#TODO: want to add "crit juice"
			#emit_signal("crit")

	queue_free() # Destroy bullet on impact
