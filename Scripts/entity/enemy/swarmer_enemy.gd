class_name SwarmerEnemy
extends BaseEnemy

@export var melee_attack_scene:PackedScene
const melee_damage := 5

@onready
var attack_sfx_player:CustomAudioStreamPlayer = $AttackSound

func _ready() -> void:
	acceleration = 800
	_cooldown = 0.5
	current_max_health = 50
	pursue_distance = 4000
	sprite = $AnimatedSprite2D
	super._ready()

func attack() -> void:
	_attacking = true
	print('Playing?')
	if attack_sfx_player:
		attack_sfx_player.play()
	player.inflict_damage(self, melee_damage)
	_attacking = false

func _handle_death():
	if attack_sfx_player:
		attack_sfx_player.stop_all()
	super._handle_death()
