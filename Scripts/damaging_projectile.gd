class_name DamagingProjectile
extends BaseProjectile

var pierce:int = 0 #Number of enemies it can pierce before disappearing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)

func _on_hit(body:Node2D):
	if (body == creator): return
	if (!(body.is_in_group('attackable'))):
		queue_free()
		return
		
	(body as Entity).inflict_damage(self, damage)
	if (pierce == 0):
		queue_free()
		return
	pierce -= 1
