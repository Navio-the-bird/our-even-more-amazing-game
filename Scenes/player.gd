class_name Player
extends Entity

@export var controller: PlayerControllerBase
@export var attack_spawn_node: Node2D

const SPEEDX: float = 800.0
const SPEEDY: float = 700.0

func _ready() -> void:
	current_speed = 3000

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	
func attack() -> void:
	print("Player attack not implemented")
	pass
