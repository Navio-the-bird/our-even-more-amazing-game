extends CharacterBody2D
class_name Entity

const DEFAULT_SPEED: float = 10000.0
const DEFAULT_MAX_HEALTH: int = 100

var sprite: Sprite2D
var animated_sprite: AnimatedSprite2D

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
			if current_health > nv:
				if sprite:
					sprite.modulate = Color.RED
					await get_tree().create_timer(0.1).timeout
					sprite.modulate = Color.WHITE
				elif animated_sprite:
					animated_sprite.modulate = Color.RED
					await get_tree().create_timer(0.1).timeout
					animated_sprite.modulate = Color.WHITE
			
			
			current_health = nv
			health_change.emit(nv)

var _alive:bool = true
var input_dir : Vector2

@export var effects: Array[Effect]:
	set(value):
		if effects != value:
			effects = value
			_caculate_current_stats()

func _ready() -> void:
	current_speed = DEFAULT_SPEED
	current_max_health = DEFAULT_MAX_HEALTH
	current_health = DEFAULT_MAX_HEALTH
	
	if not find_children("", "Sprite2D").is_empty():
		sprite = find_children("", "Sprite2D")[0]
	elif not find_children("", "AnimatedSprite2D").is_empty():
		animated_sprite = find_children("", "AnimatedSprite2D")[0]

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

func movement(delta: float) -> void:
	var input_dir : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
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
	print('Emitting health change')
	if (current_health <= 0):
		_just_died()
		return

func _just_died():
	_alive = false
	_handle_death()

func _handle_death():
	print('No custom death action!!!! Freeing object')
	queue_free()
