class_name Swarmer
extends BaseEnemy

func _ready() -> void:
	acceleration = 800

func movement(delta: float) -> void:
	var base_direction := player.global_position - global_position
	var distance = base_direction.length()
	var direction := base_direction.normalized()
	
	if (distance < attack_distance):
		print('Attacking!!!')
		velocity = Vector2(0, 0)
	else:
		velocity = velocity.move_toward(direction *max_speed, acceleration*delta)
	move_and_slide()
	if get_slide_collision_count() > 0:
		velocity = get_real_velocity()
