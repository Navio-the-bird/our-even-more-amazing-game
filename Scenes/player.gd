class_name Player
extends Entity

@export var controller: PlayerControllerBase

const SPEEDX: float = 800.0
const SPEEDY: float = 700.0

func _ready() -> void:
	current_speed = 3000

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
