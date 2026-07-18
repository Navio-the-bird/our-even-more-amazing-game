class_name RangedEnemy
extends BaseEnemy

func _ready() -> void:
	attack_distance = 2000 #Distance at which the enemy starts firing
	acceleration = 500
	_cooldown = 2
	super._ready()

func attack() -> void:
	_attacking = true
	print('About to shoot, I guess')
	_attacking = false #This should be in a callback after animation end
	
