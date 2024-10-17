extends CharacterBody2D

const speed = 80
var current_state = IDLE
var dir = Vector2.RIGHT

signal health_depleted

var health = 100.0

var start_position

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	$Timer.start()  # Ensure the timer starts at the beginning
	start_position = position

func _process(delta):
	
	if current_state == 0:
		$AnimatedSprite2D.play("idle_down_right")
	
	match current_state:
		IDLE:
			pass
		NEW_DIR:
			dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		MOVE:
			move(delta)
			
	const DAMAGE_RATE = 5.0
	var overlapping_mobs  = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0.0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%TextureProgressBar.value = health
		var texture_progress_bar = get_node("/root/World/CanvasLayer/TextureProgressBar1")
		texture_progress_bar.value = health
		#print(health, %TextureProgressBar.min_value, %TextureProgressBar.max_value)
		if health <= 0:
			health_depleted.emit()
		

func move(delta):
	#global_
	position += dir * speed * delta
	
	#play_idle_animation()
	play_movement_animation()
	#if dir.x == 1:
	#	$AnimatedSprite2D.play("idle_down_right")
	#if dir.x == -1:
	#	$AnimatedSprite2D.play("idle_down_left")
	#if dir.y == 1:
	#	$AnimatedSprite2D.play("idle_up_right")
	#if dir.y == -1:
	#	$AnimatedSprite2D.play("idle_up_right")
	
	if position.x >= start_position.x + 400:
		position.x = start_position.x + 399
	if position.x <= start_position.x - 400:
		position.x = start_position.x - 399
	if position.y >= start_position.y + 400:
		position.y = start_position.y + 399
	if position.x <= start_position.y - 400:
		position.x = start_position.y - 39	
		

func choose(array):
	#return array[randi() % array.size()]  # Pick a random element from the array
	array.shuffle()
	return array.front()


func _on_timer_timeout():
	$Timer.wait_time = choose([0.2, 0.4, 0.6])
	current_state = choose([IDLE, NEW_DIR, MOVE])
	
#func play_idle_animation():
#	if dir.x == 1:
#		$AnimatedSprite2D.play("idle_down_right")
#	elif dir.x == -1:
#		$AnimatedSprite2D.play("idle_down_left")
#	elif dir.y == 1:
#		$AnimatedSprite2D.play("idle_up_right")
#	elif dir.y == -1:
#		$AnimatedSprite2D.play("idle_up_left")

func play_movement_animation():
	if dir.x == 1:
		$AnimatedSprite2D.play("walk_down_right")
	elif dir.x == -1:
		$AnimatedSprite2D.play("walk_down_left")
	elif dir.y == 1:
		$AnimatedSprite2D.play("walk_up_right")
	elif dir.y == -1:
		$AnimatedSprite2D.play("walk_up_left")
		
func increase_health(amount):
	health = min(health + amount, 100)  # Ensure health doesn't go above max (e.g., 100)
	#print("Health increased to: ", health)
