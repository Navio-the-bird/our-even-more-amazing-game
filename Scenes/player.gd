@abstract
class_name Player
extends Entity

@export var controller: PlayerControllerBase
@export var attack_spawn_node: Node2D

#Needs to be set by child class
var projectile_scene: PackedScene

const SPEEDX: float = 800.0
const SPEEDY: float = 700.0

var cooldown:float = 1

signal death

func _ready() -> void:
	current_speed = 3000
	current_max_health = 100
	current_health = current_max_health

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	
func attack() -> void:
	if (!projectile_scene):
		print('No projectile scene!!')
		return
	var target := get_global_mouse_position()
	var instance := projectile_scene.instantiate() as DamagingProjectile
	instance.creator = self
	var dir := (target - global_position).normalized()
	const offset := 50
	instance.global_position = global_position + dir*offset
	instance.direction = target - global_position
	attack_spawn_node.add_child(instance)

func _handle_death():
	print('Player is dead!')
	
	death.emit()
