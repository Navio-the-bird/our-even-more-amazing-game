extends CharacterBody2D
class_name Entity

const DEFAULT_SPEED: float = 10000.0
const DEFAULT_MAX_HEALTH: int = 100

var current_speed: float

signal health_change(current_health:int)
signal max_health_change(current_max_health:int)
var current_max_health: int:
	set(nv):
		if current_health != nv:
			current_max_health = nv
			max_health_change.emit(nv)
var current_health: int:
	set(nv):
		if current_health != nv:
			current_health = nv
			health_change.emit(nv)

var _alive:bool = true
var input_dir : Vector2

var sprite: Node2D#AnimatedSprite2D

@export var effects: Array[Effect]:
	set(value):
		if effects != value:
			effects = value
			_caculate_current_stats()

func _ready() -> void:
	if (!current_speed):
		current_speed = DEFAULT_SPEED
	if (!current_max_health):
		current_max_health = DEFAULT_MAX_HEALTH
	current_health = current_max_health
	
	if (!sprite):
		if not find_children("", "Sprite2D").is_empty():
			sprite = find_children("", "Sprite2D")[0]
		elif not find_children("", "AnimatedSprite2D").is_empty():
			sprite = find_children("", "AnimatedSprite2D")[0]

func _caculate_current_stats():
	for effect in effects:
		if effect.name_of_the_thing_to_change in self:
			var current_value = self.get(effect.name_of_the_thing_to_change)
			if current_value is int or current_value is float:
				var new_value = current_value + effect.modification
				self.set(effect.name_of_the_thing_to_change, new_value)
			else:
				self.set(effect.name_of_the_thing_to_change, effect.modification)


func _physics_process(delta: float) -> void:
	if (!_alive): return
	movement(delta)
	update_effect(delta)

func update_effect(delta: float) -> void:
	for effect in effects:
		effect.remaining_duration -= delta

func _get_input_dir() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func movement(delta: float) -> void:
	var input_dir := _get_input_dir()
	
	if input_dir.x:
		velocity.x = input_dir.x * current_speed 
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		
	if input_dir.y:
		velocity.y = input_dir.y * current_speed
	else:
		velocity.y = move_toward(velocity.y, 0, current_speed)
	
	move_and_slide()

#TODO: Animations, invincibility frames etc
func inflict_damage(object:Node2D, value:int) -> void:
	if (!_alive): return
	current_health -= value
	_indicate_damage()
	if (current_health <= 0):
		_just_died()
		return

var damage_tween:Tween
func _indicate_damage() -> void:
	if (!sprite):
		print('No sprite set!')
		return

	if (damage_tween):
		damage_tween.kill()
	damage_tween = create_tween()
	sprite.modulate = Color(0.912, 0.0, 0.121, 0.502)
	damage_tween.tween_property(sprite, "modulate", Color.WHITE, 0.30)

func _just_died():
	_alive = false
	_handle_death()

func _handle_death():
	print('No custom death action!!!! Freeing object')
	queue_free()
