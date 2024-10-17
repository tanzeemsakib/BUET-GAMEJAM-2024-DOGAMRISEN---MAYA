extends Node2D

@onready var sprite = $Sprite2D
@onready var icon = $Sprite2D/Icon

var target_position: Vector2 = Vector2(0, 0)

func _physics_process(delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()

	set_marker_position(Rect2(top_left, size))
	set_marker_rotation()

func set_marker_position(bounds: Rect2):
	if target_position == Vector2(0, 0):  # Check if target_position is a valid position
		sprite.global_transform.origin.x = clamp(global_transform.origin.x, bounds.position.x, bounds.end.x)
		sprite.global_transform.origin.y = clamp(global_transform.origin.y, bounds.position.y, bounds.end.y)
		icon.global_rotation = 0
	else:
		var displacement = global_transform.origin - target_position
		var length

		var tl = (bounds.position - target_position).angle()
		var tr = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
		var bl = (Vector2(bounds.position.x, bounds.end.y) - target_position).angle()
		var br = (bounds.end - target_position).angle()
		if (displacement.angle() > tl && displacement.angle() < tr) \
				or (displacement.angle() < bl and displacement.angle() > br):
			var y_length = clamp(displacement.y, bounds.position.y - target_position.y, \
					bounds.end.y - target_position.y)
			var angle = displacement.angle() - PI / 2.0
			length = y_length / cos(angle) if cos(angle) != 0 else y_length
		else:
			var x_length = clamp(displacement.x, bounds.position.x - target_position.x, \
					bounds.end.x - target_position.x)
			var angle = displacement.angle()
			length = x_length / cos(angle) if cos(angle) != 0 else x_length

		# Set the new position of the sprite
		sprite.global_transform.origin = Vector2(length * cos(displacement.angle()), length * sin(displacement.angle())) + target_position

	if bounds.has_point(global_transform.origin):
		hide()
	else:
		show()

func set_marker_rotation():
	var angle = (global_transform.origin - sprite.global_transform.origin).angle()
	sprite.global_rotation = angle
