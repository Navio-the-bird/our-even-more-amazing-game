class_name RangedEnemy
extends BaseEnemy

@export var projectile_scene:PackedScene

func _ready() -> void:
	attack_distance = 2500 #Distance at which the enemy starts firing
	pursue_distance = 5000
	acceleration = 500
	_cooldown = 2
	sprite = $AnimatedSprite2D
	super._ready()

func attack() -> void:
	_attacking = true
	const offset := 10
	var base_dir := get_player_direction()
	var dir := base_dir.normalized()
	var instance := projectile_scene.instantiate() as DamagingProjectile
	instance.creator = self
	instance.global_position = global_position + dir*offset
	instance.direction = dir
	instance.global_rotation = dir.angle()
	projectile_spawn_node.add_child(instance)
	_attacking = false #This should be in a callback after animation end
	
