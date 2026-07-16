class_name Enemy
extends Node2D

@export var config: EnemyTowerConfig
@export var enemies: Array[EnemyInfo]
@export var enemy_container: Node2D

@export var player: Player

var timer: Timer
var living_enemies: Array[BaseEnemy]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = %SpawnTimer
	timer.timeout.connect(_try_spawn)
	_set_timer_rand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_timer_rand() -> void:
	var r: float = randf_range(config.MIN_TIME_BETWEEN_SPAWN, config.MAX_TIME_BETWEEN_SPAWN)
	timer.wait_time = r
	timer.start()

#Can be overridden
func _try_spawn() -> void:
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
	
	#Chuck it into the scene
	instance.player = player
	instance.global_position = _get_random_enemy_spawn()
	enemy_container.add_child(instance)
	
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
