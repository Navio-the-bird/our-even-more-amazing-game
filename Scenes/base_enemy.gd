class_name BaseEnemy
extends Entity

signal death(object_ref:BaseEnemy)

var player:Player
var max_speed = 1000
var acceleration = 200

var pursue_distance: float = 2000 #Distance at which to start pursuing player
var attack_distance:float = 100
var _pursuing:bool = false
var _attacking:bool = false
var _cooling_down := false
var _cooldown: float =  1

var projectile_spawn_node:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Cooldown.wait_time = _cooldown
	%Cooldown.timeout.connect(_reset_cooldown)
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _try_attack() -> void:
	if (_attacking || _cooling_down): return
	self.attack()
	_cooling_down = true
	%Cooldown.start()

func _reset_cooldown() -> void:
	print('Attack cooldown done')
	_cooling_down = false

#I considered making a base scene and adding a cooldown timer to it, 
#then letting child scenes use it and provide their own cooldown
#I decided that maybe the children would need too-specific implementations wrt animations etc
func attack() -> void:
	_attacking = true
	print("Attacking!!! .......except it's not implemented yet :>")
	_attacking = false

#Returns direction UN-NORMALISED to allow distance calc
func get_player_direction() -> Vector2:
	var base_direction := player.global_position - global_position
	return base_direction

func movement(delta: float) -> void:
	var base_direction := get_player_direction()
	var distance := base_direction.length()
	_pursuing = distance < pursue_distance
		
	if (!_pursuing): 
		#Ideally do idle movements or something
		return
	var direction := base_direction.normalized()
	
	if (distance < attack_distance):
		velocity = Vector2(0, 0)
		_try_attack()
	else:
		velocity = velocity.move_toward(direction *max_speed, acceleration*delta)
	move_and_slide()
	if get_slide_collision_count() > 0:
		velocity = get_real_velocity()
