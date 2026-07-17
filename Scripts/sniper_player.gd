extends Player

@export var sniper_bullet:PackedScene

#Duplicated from the melee player. Technically the base player could contain this function if all players will effectively be using ranged weapons
func attack() -> void:
	var target := get_global_mouse_position()
	var instance := sniper_bullet.instantiate() as DamagingProjectile
	var dir := (target - global_position).normalized()
	const offset := 50
	instance.global_position = global_position + dir*offset
	instance.direction = target - global_position
	attack_spawn_node.add_child(instance)
