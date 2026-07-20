@abstract
class_name Player
extends Entity

#@export var controller: PlayerControllerBase
@export var attack_spawn_node: Node2D

#Needs to be set by child class
var projectile_scene: PackedScene
var attack_cooldown: float = 0.15
var can_attack: bool = true

const SPEEDX: float = 800.0
const SPEEDY: float = 700.0

var cooldown:float = 1

signal player_attack
signal death
var player_death_animation_played:bool = false

@onready
var attack_sfx_player:= $AttackSound

@onready
var walk_sfx_player: CustomAudioStreamPlayer = $WalkSound

var playing_walking_sound:bool = false

func _ready() -> void:
	current_speed = 3000
	current_max_health = 150
	current_health = current_max_health

func _physics_process(delta: float) -> void:
	if (velocity.length() > 1):
		if (!walk_sfx_player.currently_playing):
			walk_sfx_player.play()
	elif walk_sfx_player.currently_playing:
		walk_sfx_player.stop_all()
		
	if (!_alive): return
	super._physics_process(delta)
	if Input.is_action_pressed("attack") and can_attack:
		attack()
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
	
func attack() -> void:
	if (!projectile_scene):
		print('No projectile scene!!')
		return
	attack_sfx_player.play()
	var target := get_global_mouse_position()
	var dir := (target - global_position).normalized()
	var instance := projectile_scene.instantiate() as DamagingProjectile
	const offset := 50
	instance.creator = self
	instance.global_rotation = dir.angle()
	instance.global_position = global_position + dir*offset
	instance.direction = target - global_position
	attack_spawn_node.add_child(instance)
	player_attack.emit()

func _handle_death():
	print('Player is dead!')
	
	death.emit()
	
func _get_attack_direction() -> Vector2:
	var target := get_global_mouse_position()
	var dir := (target - global_position).normalized()
	return dir
