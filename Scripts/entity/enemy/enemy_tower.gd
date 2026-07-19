class_name EnemyTower
extends Entity

## Tower config
@export var config: EnemyTowerConfig

## List of possible enemies to spawn
@export var enemies: Array[EnemyInfo]

## Container for all enemy nodes, can be shared across towers
@export var enemy_container: Node2D

## Reference to the player node
@export var player: Player

@export var drop_pod_scene: PackedScene
@export var broken_tower_scene: PackedScene

var timer: Timer
var living_enemies: Array[BaseEnemy]
var _viewport_height:float

#Signal for when the tower gets destroyed. I realise we could consolidate every death signal into the entity class but we're pretty damn short on time >v<
signal destruction(object_ref:EnemyTower)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_viewport_height = get_viewport_rect().size.y / get_canvas_transform().get_scale().y
	timer = %SpawnTimer
	current_max_health = 5000
	timer.timeout.connect(_try_spawn)
	_set_timer_rand()
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_timer_rand() -> void:
	var r: float = randf_range(config.MIN_TIME_BETWEEN_SPAWN, config.MAX_TIME_BETWEEN_SPAWN)
	timer.wait_time = r
	timer.start()

#Can be overridden
func _try_spawn() -> void:
	#return
	var length := len(enemies)
	if (length == 0):
		print('No enemies')
		return
		
	if (len(living_enemies) >= config.MAX_NUM_ENEMIES):
		print("Enemy count saturated")
		_set_timer_rand()
		return
		
	var index: int = randi() % length
	var instance: BaseEnemy = enemies[index].scene.instantiate() as BaseEnemy
	
	#Track enemy
	living_enemies.push_back(instance)
	instance.death.connect(_enemy_died)
	instance.player = player
	
	#Chuck it into the scene with a pod
	var spawn_offset := Vector2(0,  _viewport_height + 100)
	var pod_instance := drop_pod_scene.instantiate() as DropPod
	pod_instance.destination = _get_random_enemy_spawn()
	pod_instance.global_position = pod_instance.destination - spawn_offset
	pod_instance.enemy = instance
	enemy_container.add_child(pod_instance)
	
	_set_timer_rand()

func _get_random_enemy_spawn() -> Vector2:
	var angle: float = randf_range(0, PI*2)
	# Would you still love me if I were a donut?
	var distance: float = sqrt(randf_range(config.MIN_RADIUS_FOR_SPAWN ** 2, config.MAX_RADIUS_FOR_SPAWN ** 2))
	return position + Vector2(cos(angle), sin(angle)) * distance

func _enemy_died(instance:BaseEnemy) -> void:
	living_enemies.erase(instance)
	#Play death animation or whatever
	instance.queue_free()

func movement(delta: float) -> void:
	return

func _handle_death():
	var instance := broken_tower_scene.instantiate() as Node2D
	instance.global_position = global_position
	get_parent().add_child(instance)
	destruction.emit(self)
	queue_free()
