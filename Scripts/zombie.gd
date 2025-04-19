extends CharacterBody2D

@export var speed: float = 50
@onready var animation = $AnimatedSprite2D
@onready var health_bar = $ProgressBar
var player: Node2D = null
var terry: Node2D = null
var target: Node2D = null
var targets: Array

func _ready():
	player = get_tree().get_first_node_in_group("player")
	terry = get_tree().get_first_node_in_group("terry")
	targets = [terry, terry, terry, player]
	health_bar.value = 100
	
	target = targets.pick_random()
func _physics_process(delta):
	if target: # Ensures we dont have a null value
		# Once zombie has closed the distance, it latches to the player. This may be 
		# from normalized(), as it mentions possible issues if the input Vector is near zero.
		# Right now you can kill the zombie and its not a big deal that it latches.
		# TODO: But I need to eventually address this if time permits.
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		animation.play()

func _process(delta):
	if health_bar.value <= 0:
		set_process(false)
		set_physics_process(false)
		$CollisionShape2D.disabled = true
		self.hide()
		$DeathSound.play()

func shot(damage: int):
	health_bar.value = health_bar.value - damage
	$AudioStreamPlayer2D.play()


func _on_death_sound_finished():
	queue_free()
