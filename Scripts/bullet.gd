extends Area2D


var speed: float = 800
var velocity: Vector2 

func _ready():
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	
func _process(delta):
	global_position += velocity * delta
	
func set_velocity(bullet_speed: float):
	speed = bullet_speed
	


func _on_body_entered(body):
	# Zombies will have health so, they wont be one shot. This is temporary.
	if body.is_in_group("basic_zombie"):
		body.queue_free() # Don't know if we have to "set defered physics" at some point? Like we did in 
	# dodge the creeps. I don;t know if it will matter for preformance later on.
	queue_free() # Destroy bullet on impact
