extends Node

var spawners_array: Array = []
@export var enemy_scenes: Array = []
@onready var spawn_timer = $SpawnTimer

func _ready():
	spawners_array = get_tree().get_nodes_in_group("spawner")
	spawn_timer.start()
	

func _on_crit():
	print("CRIT RECEIVED!!!")
#TODO Need to do something about the custome ghetto scaling for sprites that i'm doing currently.

# TODO: Make it so zombies dont spawn if the player is in the area. I dont ever
# want the player to see a zombie spawn. Should always feel like they're coming from off screen
# (and they should be)

# - Make player's area2D disable spawners in view. Defer spawns to open 
# out of view spawners.

# - **Possibly make it so zombies wont randomly spawn at a spawner more than twice.
# Do something like "last_spawn = current_spawn" if next iteration they are the same then
# same_location_count += 1. If count => 2, then run it again until its different. It 
# needs to be quick though. Otherwise you could have greater delays in spawning. 
func _on_spawn_timer_timeout():
	var current_spawn = spawners_array.pick_random()
	current_spawn.spawn(enemy_scenes.pick_random())
