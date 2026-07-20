extends Node2D

const MIN_ENEMIES_PER_TOWER:int = 5 #The minimum value for a towers maximum
const MAX_ENEMIES_PER_TOWER:int = 15
const TOWER_MIN_SPAWN_RADIUS:float = 1000
const TOWER_MAX_SPAWN_RADIUS:float = 5000

#TIme in seconds
const TOWER_MIN_TIME_BETWEEN_SPAWN = 0
const TOWER_MAX_TIME_BETWEEN_SPAWN = 10

#The radius around the player spawn where the towers start appearing
const TOWER_POSITION_MIN_RADIUS = 1000
const TOWER_POSITION_MAX_RADIUS = 20000

@export var katana_player_scene:PackedScene
@export var sniper_player_scene:PackedScene
@export var tower_scene:PackedScene
@export var drop_pod_scene:PackedScene

@export var background: PackedScene

@export var possible_enemies : Array[EnemyInfo]
var camera:Camera2D

var player:Player

var active_enemy_towers: Array[EnemyTower]

var battle_track_player:CustomAudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active_enemy_towers = []
	if randf() < 0.5:
		battle_track_player = %BattleTrack1
	else:
		battle_track_player = %BattleTrack2
		
	battle_track_player.play()
	await get_tree().create_timer(1).timeout
	%MainMenu/PlayerSelect.SelectedKatanaPlayer.connect(_select_player_katana)
	%MainMenu/PlayerSelect.SelectedSniperPlayer.connect(_select_player_sniper)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _select_player_katana() -> void:
	player = katana_player_scene.instantiate()
	_start_combat()


func _select_player_sniper() -> void:
	player = sniper_player_scene.instantiate()
	_start_combat()
	
func _clear_combat():
	for child in %CombatContainer.get_children():
		child.queue_free()
	
func _on_pause_menu_quit_game() -> void:
	_clear_combat()
	%Hud.hide()
	%PauseMenu.hide()
	%MainMenu.show()

func _on_tower_destroy(obj:EnemyTower):
	active_enemy_towers.erase(obj)
	%Hud.set_tower_count(len(active_enemy_towers))
	pass

func _start_combat():
	#First take out the trash
	_clear_combat()
	
	player.death.connect(on_player_death)
	%CombatContainer.add_child(background.instantiate())
	
	
	var config_array: Array[EnemyTowerConfig] = []
	for i in range(TOWER_AMT):
		config_array.push_back(_get_random_tower_config())
	
	active_enemy_towers = []
	spawn_a_shitload_of_towers(config_array, %CombatContainer, %CombatContainer )
	
	camera = Camera2D.new()
	camera.zoom = Vector2(0.2, 0.2)
	camera.position_smoothing_enabled = true
	camera.make_current()
	
	#%Hud.max_player_health = player.current_max_health
	#%Hud.current_player_health = player.current_health
	player.health_change.connect(%Hud.set_player_health)
	player.max_health_change.connect(%Hud.set_player_max_health)
	player.attack_spawn_node = %CombatContainer
	player.add_child(camera)
	%CombatContainer.add_child(player)
	%MainMenu.hide()
	%Hud.set_tower_count(TOWER_AMT)
	%Hud.show()

func _get_random_tower_config():
	var tc := EnemyTowerConfig.new()
	tc.MAX_NUM_ENEMIES = randi_range(MIN_ENEMIES_PER_TOWER, MAX_ENEMIES_PER_TOWER)
	
	tc.MIN_RADIUS_FOR_SPAWN = TOWER_MIN_SPAWN_RADIUS
	tc.MAX_RADIUS_FOR_SPAWN = TOWER_MAX_SPAWN_RADIUS
	
	tc.MIN_TIME_BETWEEN_SPAWN = TOWER_MIN_TIME_BETWEEN_SPAWN
	tc.MAX_TIME_BETWEEN_SPAWN = TOWER_MAX_TIME_BETWEEN_SPAWN
	
	return tc


func on_player_death():
	#battle_track_player.stop_all()
	%GameOverMenu.game_over()

###### Prootzel's tower generation below

## A small script for spawning towers

## TODO: Put those somewhere else

## The minimum distance between 2 towers for a new attempt to be made
var MIN_DIST : int = 20000
## The max amount of attempts to find a tower position
var MAX_ATTEMPTS : int = 3
## The amount of towers to spawn
var TOWER_AMT : int = 10

## The chance that each tower can spawn multiple different enemies
var MULTIPLE_ENEMY_CHANCE : int = 20

## If multiple enemies gets picked as the enemy list, the chance of each individual member appearing
var PICK_ENEMY_CHANCE : int = 10

## Generates a random enemy tower list from a list of possible enemies
func generate_enemy_tower_list(dup_enemy_list : Array[EnemyInfo]) -> Array[EnemyInfo]:
	if(randi_range(0, 100) < MULTIPLE_ENEMY_CHANCE):
		# pick multiple enemies randomly
		var e = dup_enemy_list.filter(func(__):  return randi_range(0, 100) < PICK_ENEMY_CHANCE)
		if(e.size() >= 1): return e
	
	# pick 1 random enemey
	return [dup_enemy_list[randi_range(0, dup_enemy_list.size()-1)]]


## Generates a lot of towers and returns their holder
## "Sets the scene, romantically" 
## - @Navio
func spawn_a_shitload_of_towers(
		tc : Array[EnemyTowerConfig], 
		enemy_container : Node2D,
		tower_holder : Node2D,
	) -> void:
	
	var current_towers : Array[Vector2]	
	var dup_enemy_list : Array[EnemyInfo]
	
	# Create a list with multiple duplicates of each enemy info for "weighted randomness"
	for e in possible_enemies:
		for i in range(5):
			dup_enemy_list.append(e)
	
	for i in range(TOWER_AMT):
		var enemy_list = generate_enemy_tower_list(dup_enemy_list)
		
		var tower := create_tower(
			enemy_list,
			player,
			tc[i],
			current_towers,
			enemy_container,
		)
		
		tower_holder.add_child(tower)
		active_enemy_towers.push_back(tower)
		tower.destruction.connect(_on_tower_destroy)
		current_towers.append(tower.global_position)


## Creates and initialises a tower and add it to the children of tower_parent
func create_tower(
		enemy_list : Array[EnemyInfo], 
		player_ref : Player, 
		tc : EnemyTowerConfig,
		current_towers : Array[Vector2],
		enemy_container : Node2D,
	) -> EnemyTower:
	var tower: EnemyTower = tower_scene.instantiate()
	
	tower.config = tc
	tower.player = player_ref
	tower.enemies = enemy_list
	tower.enemy_container = enemy_container
	tower.drop_pod_scene = drop_pod_scene
	
	var pos = generate_random_tower_coordinates(tc, current_towers)
	tower.global_position = pos

	return tower


func generate_random_tower_coordinates(tc : EnemyTowerConfig, current_towers : Array[Vector2]) -> Vector2:
	var min_dist_squared = MIN_DIST**2
	
	var pos := Vector2(0, 0)
	
	var attempt_spawn = true
	var i = 0
	
	while attempt_spawn:
		var angle = randf_range(0, 2 * PI)
		var dist = randf_range(TOWER_POSITION_MIN_RADIUS, TOWER_POSITION_MAX_RADIUS)
		
		pos = Vector2(dist * cos(angle), dist * sin(angle))
		var found_pos = true
		
		for other_pos in current_towers:
			if(pos.distance_squared_to(other_pos) >= min_dist_squared):
				found_pos = false
				break
		
		attempt_spawn = (not found_pos) and (i < MAX_ATTEMPTS)
		i+=1
		
	return pos
