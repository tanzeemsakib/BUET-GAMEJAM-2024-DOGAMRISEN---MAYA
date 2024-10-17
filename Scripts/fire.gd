extends CharacterBody2D

@export var speed = 200
#var mouse_position = null

signal health_depleted

@export var health: float = 100.0
@export var damage_per_second: float = 2.0

@onready var all_interactions = []
@onready var interactlabel = $"Interaction Components/Interact Label"


func _ready():
	update_interactions()
	
	if Input.is_action_just_pressed("left_click"):
		execute_interaction()
	

func _physics_process(delta: float) -> void:
	
	if health > 0:
		#velocity = Vector2(0, 0)
		var vel: Vector2 = (get_global_mouse_position() - global_position)
		#mouse_position = get_global_mouse_position()
	
		#if Input.is_action_pressed("forward"):
			#var direction = (mouse_position - position).normalized()
			#velocity = (direction * speed)
		
		if vel.length() > 100:
			vel = vel.normalized() * 500
		
		velocity = vel
		
		move_and_slide()
	#look_at(mouse_position)
	
	health -= damage_per_second * delta
	%TextureProgressBar.value = health
	var texture_progress_bar = get_node("/root/World/CanvasLayer/TextureProgressBar2")
	texture_progress_bar.value = health
	#print(health)
	if health <= 0:
		health_depleted.emit()
		die()
	


func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()
	
func update_interactions():
	if all_interactions:
		interactlabel.text = all_interactions[0].interact_label
	else:
		interactlabel.text = ""
		
func execute_interaction():
	if all_interactions:
		var current_interaction = all_interactions[0]
		match current_interaction.interact_type:
			"print_text" : print(current_interaction.interact_value)

func die():
	velocity = Vector2.ZERO  # Stop movement when health is depleted
	pass
	
func increase_health(amount):
	health = min(health + amount, 100)  # Ensure health doesn't go above max (e.g., 100)
	#print("Health increased to: ", health)
