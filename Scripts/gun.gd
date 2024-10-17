extends Area2D

@export var max_ammo: int = 10  # Maximum ammo
var current_ammo: int  # Current ammo
var ammo_label: Label  # Reference to the ammo label

# Called when the node enters the scene tree for the first time.
func _ready():
	current_ammo = max_ammo  # Initialize current ammo to maximum at start
	# You may want to set up a UI element to display current ammo
		# Assuming the Label node is named "AmmoLabel" and is a sibling or child of this node.
	ammo_label = get_node("/root/World/CanvasLayer/AmmoLabel")
	update_ammo_display()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
		
func shoot():
	if current_ammo > 0:  # Check if there is ammo left
		const BULLET = preload("res://Scenes/projectile.tscn")
		var new_bullet = BULLET.instantiate()
		
		%ShootingPoint.add_child(new_bullet)
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		
		current_ammo -= 1  # Decrease ammo count
		# Optional: Update UI here to show ammo change
		update_ammo_display()  # Update the ammo display
	else:
		# Optional: Play a "no ammo" sound or show a message
		#print("Out of ammo!")
		pass


func _on_timer_timeout():
	shoot()
	
func update_ammo_display():
	# Update the label with the current ammo count
	ammo_label.text = "Ammo: " + str(current_ammo)
	
func increase_ammo(amount):
	current_ammo += amount
	#min(current_ammo + amount, 10)  # Ensure health doesn't go above max (e.g., 100)
	# print("Ammo increased to: ", current_ammo)
