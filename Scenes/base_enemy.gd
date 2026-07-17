class_name BaseEnemy
extends Entity

signal death(object_ref:BaseEnemy)

var player:Player
var max_speed = 1000
var acceleration = 200

var attack_distance:float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack() -> void:
	print("Attacking!!! .......except it's not implemented yet :>")

#Returns direction UN-NORMALISED to allow distance calc
func get_player_direction() -> Vector2:
	var base_direction := player.global_position - global_position
	return base_direction

func movement(delta: float) -> void:
	var base_direction := get_player_direction()
	var distance := base_direction.length()
	var direction := base_direction.normalized()
	
	if (distance < attack_distance):
		velocity = Vector2(0, 0)
		attack()
	else:
		velocity = velocity.move_toward(direction *max_speed, acceleration*delta)
	move_and_slide()
	if get_slide_collision_count() > 0:
		velocity = get_real_velocity()
