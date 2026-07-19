extends Player

@export var sniper_bullet:PackedScene

func _ready() -> void:
	projectile_scene = sniper_bullet
	attack_cooldown = 0.3
	super._ready()
	
