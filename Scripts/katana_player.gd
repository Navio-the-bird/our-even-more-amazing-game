extends Player

@export var melee_attack:PackedScene

func _ready() -> void:
	projectile_scene = melee_attack
	cooldown = 0.1
	super._ready()
