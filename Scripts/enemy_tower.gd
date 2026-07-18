class_name Enemy
extends Entity

@export var config: EnemyTowerConfig
@export var enemies: Array[EnemyInfo]
@export var enemy_container: Node2D

@export var player: Player
@export var drop_pod_scene: PackedScene

var timer: Timer
var living_enemies: Array[BaseEnemy]
var _viewport_height:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_viewport_height = get_viewport_rect().size.y / get_canvas_transform().get_scale().y
	timer = %SpawnTimer
	current_max_health = 500
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
