extends Control

@onready var timer = $TimerPROTO
@onready var timer_label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rough timer system prototype.
	timer_label.text = str(timer.time_left)
