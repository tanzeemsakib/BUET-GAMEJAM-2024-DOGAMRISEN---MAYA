extends CharacterBody2D

var health = 2

@onready var player = get_node("/root/World/MC")

func _ready():
	$AnimatedSprite2D.play("walk")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 20	
	move_and_slide()
	
func take_damage():
	health -= 1
	$AnimatedSprite2D.play("hurt")
	
	if health == 0:
		queue_free()
		
		const SMOKE_SCREEN = preload("res://Scenes/dead.tscn")
		var smoke = SMOKE_SCREEN.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
