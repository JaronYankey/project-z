extends CharacterBody2D

# Player movement speed
var speed = 175
var power_ready: bool = false # Will be used to moderate ability use.
var ability = func(): print("No ability selected!!") # Defualt message for now


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	if Input.is_action_pressed("special_power"):
		# Must use .call() on the var ability to get the function to run.
		ability.call() # Run the appropriate function for the power the player has.
	
func set_power(power: String):
	if power == "nimble":
		ability = dash # No parentheses because its assignment, not a call to dash()

func dash():
	print("I DASHED FORWARD!!!")
	
func riot_charge():
	pass
	
func bullet_frenzy():
	pass
