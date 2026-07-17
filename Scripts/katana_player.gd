extends Player

@export var melee_attack:PackedScene

func attack() -> void:
	var target := get_global_mouse_position()
	var instance := melee_attack.instantiate() as Melee
	var dir := (target - global_position).normalized()
	const offset := 50
	instance.global_position = global_position + dir*offset
	instance.direction = target - global_position
	attack_spawn_node.add_child(instance)
