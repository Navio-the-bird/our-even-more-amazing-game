class_name Player
extends CharacterBody2D

@export var controller:PlayerControllerBase

const SPEEDX = 800.0
const SPEEDY = 700.0

func _physics_process(delta: float) -> void:
	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX := Input.get_axis("ui_left", "ui_right")
	var directionY := Input.get_axis("ui_up", "ui_down")
	if directionX:
		velocity.x = directionX * SPEEDX 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEEDX)
		
	if directionY:
		velocity.y = directionY * SPEEDY
	else:
		velocity.y = move_toward(velocity.y, 0, SPEEDY)

	move_and_slide()
