extends Player

@export var sniper_bullet:PackedScene
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var facing_right: bool = true

func _ready() -> void:
	projectile_scene = sniper_bullet
	attack_cooldown = 0.3
	super._ready()
	
func _process(delta: float) -> void:
	_handle_animation()

	

func _handle_animation():
	if (!_alive):
		if (!player_death_animation_played):
			animated_sprite_2d.play("die")
		return
 
	var is_attacking := Input.is_action_pressed("attack")
 
	if is_attacking:
		var attack_dir := _get_attack_direction()
		if attack_dir.x != 0:
			facing_right = attack_dir.x > 0
		var standing := velocity == Vector2.ZERO
		if facing_right:
			animated_sprite_2d.play("attack_stand_right" 
			if standing else "attack_right")
		else:
			animated_sprite_2d.play("attack_stand_left" 
			if standing else "attack_left")
		return
		
	if velocity == Vector2.ZERO:
		animated_sprite_2d.play("idle")
		return
		
	if velocity.x != 0:
		animated_sprite_2d.play("walk_right" 
		if velocity.x > 0 else "walk_left")
		return
		
	if velocity.y != 0:
		animated_sprite_2d.play("front_run" 
		if velocity.y > 0 else "back_run")
		return
