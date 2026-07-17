class_name BaseProjectile
extends Node2D

@export var direction:Vector2
@export var speed:int = 9000
@export var lifetime:int = 40000 #lifetime in distance

var destination:Vector2
const threshold = 0.1 #At which threshold to end the lifecycle of this attack. Just a way to avoid == with floating points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destination = global_position + direction.normalized()*lifetime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ((destination - global_position).length() < threshold): 
		queue_free()
		return
	global_position = global_position.move_toward(destination, speed*delta)
