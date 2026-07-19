extends Player

@export var sniper_bullet:PackedScene

func _ready() -> void:
	projectile_scene = sniper_bullet
	super._ready()
	
