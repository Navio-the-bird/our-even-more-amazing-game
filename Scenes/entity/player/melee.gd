class_name Melee
extends DamagingProjectile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 9000
	lifetime = 400
	damage = 40
	pierce = 0
	super._ready()

func _on_collide(body: Node2D) -> void:
	_on_hit(body)
