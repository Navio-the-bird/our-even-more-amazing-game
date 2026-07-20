class_name DropPod
extends CharacterBody2D

#The vertical distance the pod falls. To be set before entering scene tree. 
var destination:Vector2
var speed:int = 2000
var opening_delay:float = 1 #The delay before the pod opens

#A reference to the enemy to spawn. The alternative is that we set the packed_scene and pass data for the enemy as a resource
#However I think this works fine and is simpler anyway
var enemy:Entity 
var _dropped := false
var _opened := false
const threshold: float = 1 #The threshold at which to decide we've reached our destination

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (_dropped): return
	global_position = global_position.move_toward(destination, speed*delta)
	if (destination - global_position).length() < threshold:
		_dropped = true
		$CollisionShape2D.set_deferred("disabled", false) #Enable collisions now
		%OpeningTimer.wait_time = opening_delay
		%OpeningTimer.timeout.connect(_on_open)
		%OpeningTimer.start()


func _on_open() -> void:
	if (_opened): return
	#Spawn here
	enemy.global_position = global_position
	var parent := get_parent()
	(enemy as BaseEnemy).projectile_spawn_node = parent
	parent.add_child(enemy)
	queue_free()
	_opened = true

#Just in case something needs it, though right now the pod is freed anyway
func is_open() -> bool:
	return _opened
