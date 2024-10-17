extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("fire")
@onready var player2 = get_tree().get_first_node_in_group("mc")

const MAX_SPEED = 50.0
const ACCELERATION = 0.5

var speed = 0.0
var is_being_picked_up = false

func _physics_process(delta):
	if is_being_picked_up:
		speed = lerp(speed, MAX_SPEED, ACCELERATION * delta)
		velocity = global_position.direction_to(player.global_position) * speed
	
	var collision = move_and_collide(velocity)
	
	if collision:
		_handle_picked_up()
		
func _handle_picked_up():
	if player2.has_method("increase_health"):
		player2.increase_health(10)  # Adjust the amount of health as needed
	queue_free()


func _on_mouse_entered():
	is_being_picked_up = true
