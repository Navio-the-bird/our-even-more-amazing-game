#class_name EnemyProjectile
extends DamagingProjectile

func _ready() -> void:
	speed = 9000
	lifetime = 4000
	damage = 40
	pierce = 1
	super._ready()

func _on_collide(body: Node2D) -> void:
	_on_hit(body)
