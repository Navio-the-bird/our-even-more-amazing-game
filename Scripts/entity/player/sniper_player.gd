extends Player

@export var sniper_bullet:PackedScene
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking: bool = false

func _ready() -> void:
	projectile_scene = sniper_bullet
	attack_cooldown = 0.3
	player_attack.connect(_play_attack_animation)
	super._ready()
	
func _process(delta: float) -> void:
	if not is_attacking:
		_handle_animation()

func _handle_animation():
	if (!_alive):
		if (!player_death_animation_played):
			animated_sprite_2d.play("die")
			player_death_animation_played = true
		return
	if velocity == Vector2.ZERO:
		animated_sprite_2d.play("idle")
	if velocity.x != 0:
		if velocity.x > 0:
			animated_sprite_2d.play("walk_right")
		else:
			animated_sprite_2d.play("walk_left")
		return
	if velocity.y != 0:
		if velocity.y > 0:
			animated_sprite_2d.play("front_run")
		else:
			animated_sprite_2d.play("back_run")
			
func _play_attack_animation():
	
	if is_attacking:
		return
	is_attacking = true
	var attack_dir := _get_attack_direction()
	if attack_dir.x != 0:
		if attack_dir.x > 0:
			animated_sprite_2d.play("attack_right")
		else:
			animated_sprite_2d.play("attack_left")
		
	else:
		if attack_dir.y != 0:
			if attack_dir.y > 0:
				animated_sprite_2d.play("attack_front")
			else:
				animated_sprite_2d.play("attack_back")
	await animated_sprite_2d.animation_finished
	is_attacking = false
