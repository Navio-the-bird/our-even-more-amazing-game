## A small script for spawning towers

## TODO: Put those somewhere else

## The minimum distance between 2 towers for a new attempt to be made
var MIN_DIST : int = 25
## The max amount of attempts to find a tower position
var MAX_ATTEMPTS : int = 3
## The amount of towers to spawn
var TOWER_AMT : int = 100

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
		tc : EnemyTowerConfig, 
		possible_enemies : Array[EnemyInfo],
		player_ref : Player,
		enemy_container : Node2D,
		drop_pod_scene : PackedScene
	) -> Node:	
	var tower_holder : Node
	var current_towers : Array[Vector2]
	
	var dup_enemy_list : Array[EnemyInfo]
	
	# Create a list with multiple duplicates of each enemy info for "weighted randomness"
	for e in possible_enemies:
		for i in range(5):
			dup_enemy_list.append(e)
	
	for i in range(TOWER_AMT):
		var enemy_list = generate_enemy_tower_list(dup_enemy_list)
		
		var tower = create_tower(
			enemy_list,
			player_ref,
			tc,
			current_towers,
			tower_holder,
			enemy_container,
			drop_pod_scene
		)
		
		current_towers.append(tower.global_position)
	
	return tower_holder


## Creates and initialises a tower and add it to the children of tower_parent
func create_tower(
		enemy_list : Array[EnemyInfo], 
		player_ref : Player, 
		tc : EnemyTowerConfig,
		current_towers : Array[Vector2],
		tower_parent : Node,
		enemy_container : Node2D,
		drop_pod_scene : PackedScene
	) -> EnemyTower:
	var tower : EnemyTower
	
	tower.config = tc
	tower.player = player_ref
	tower.enemies = enemy_list
	tower.enemy_container = enemy_container
	tower.drop_pod_scene = drop_pod_scene
	
	var pos = generate_random_tower_coordinates(tc, current_towers)
	tower.global_position = pos
	
	tower_parent.add_child(tower)
	
	return tower


func generate_random_tower_coordinates(tc : EnemyTowerConfig, current_towers : Array[Vector2]) -> Vector2:
	var min_dist_squared = MIN_DIST**2
	
	var pos : Vector2
	
	var attempt_spawn = true
	var i = 0
	
	while attempt_spawn:
		var angle = randf_range(0, 2 * PI)
		var dist = randf_range(tc.MIN_RADIUS_FOR_SPAWN, tc.MAX_RADIUS_FOR_SPAWN)
		
		pos.x = dist * cos(angle)
		pos.y = dist * sin(angle)
		
		var found_pos = true
		
		for other_pos in current_towers:
			if(pos.distance_squared_to(other_pos) >= min_dist_squared):
				found_pos = false
				break
		
		attempt_spawn = (not found_pos) and (i < MAX_ATTEMPTS)
		i+=1
		
	return pos
