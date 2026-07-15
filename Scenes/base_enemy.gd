class_name BaseEnemy
extends CharacterBody2D

signal death(object_ref:BaseEnemy)
var player:Player
var max_speed = 2
var acceleration = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := player.global_position - global_position
	velocity = velocity.move_toward(direction*max_speed, acceleration)
	move_and_slide()
