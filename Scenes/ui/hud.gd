extends Control

var current_player_health:int = 20
var max_player_health:int = 20
var tower_count:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%HealthBar.value = current_player_health
	%HealthBar.max_value = max_player_health
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_player_health(value:int):
	current_player_health = value
	%HealthBar.value = current_player_health
	
func set_player_max_health(value:int):
	max_player_health = value
	%HealthBar.max_value = max_player_health

func set_tower_count(value:int):
	tower_count = value
	%TowerCount.text = str(tower_count)
