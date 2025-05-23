extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/RetryButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_retry_button_pressed():
	#print("Retry button pressed")
	get_tree().paused = false  # Unpause the game
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_home_button_pressed():
	#print("Home button pressed")
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
