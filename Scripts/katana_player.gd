extends Player

@export var melee_attack:PackedScene

func _ready() -> void:
	projectile_scene = melee_attack
	super._ready()
