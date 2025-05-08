extends CharacterBody2D

@export var speed: float = 50
@export var death_sound: AudioStream
@export var getting_shot_sound: AudioStream

@onready var animation = $AnimatedSprite2D
@onready var health_bar = $ProgressBar
@onready var audio = $AudioStreamPlayer2D
@onready var death_audio = $DeathSound

var player: Node2D = null
var terry: Node2D = null
var target: Node2D = null
var targets: Array

func _ready():
	player = get_tree().get_first_node_in_group("player")
	terry = get_tree().get_first_node_in_group("terry")
	targets = [terry, terry, terry, player]
	health_bar.value = 100
	
	#target = targets.pick_random()
func _physics_process(delta):
	if target: # Ensures we dont have a null value
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		animation.play()
	else:
		animation.stop()

func _process(delta):
	if health_bar.value <= 0:
		set_process(false)
		set_physics_process(false)
		$CollisionShape2D.disabled = true
		self.hide()
		death_audio.play()

func hit(damage: int):
	health_bar.value = health_bar.value - damage
	audio.stream = getting_shot_sound
	audio.play()


func _on_death_sound_finished():
	queue_free()


func _on_line_of_sight_area_entered(area):
	pass


func _on_line_of_sight_area_exited(area):
	pass


func _on_line_of_sight_body_entered(body):
	if body.is_in_group("living"):
		target = body


func _on_line_of_sight_body_exited(body):
	if body.is_in_group("living"):
		target = null
