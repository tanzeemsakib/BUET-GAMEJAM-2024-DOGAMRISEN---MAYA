extends Node2D

func _ready():
	DialogueManager.show_dialogue_balloon(load("res://Dialog/main.dialogue"))
	return

func spawn_mob():
	var new_mob = preload("res://Scenes/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout():
	spawn_mob()


func _on_mc_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true
