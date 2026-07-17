class_name Melee
extends BaseProjectile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	speed = 9000
	lifetime = 400
