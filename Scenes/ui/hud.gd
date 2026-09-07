extends Control

var current_player_health:int = 20
var max_player_health:int = 20
var tower_count:int = 0

func _init() -> void:
	self.hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%HealthBar.value = current_player_health
	%HealthBar.max_value = max_player_health
	

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

func dim_mission_text():
	%MissionText.show()
	%MissionText.modulate = Color.WHITE
	
	await get_tree().create_timer(3.5).timeout
	await create_tween().tween_property(%MissionText, "modulate", Color.TRANSPARENT, 2.0).set_trans(Tween.TRANS_SINE).finished
	
	%MissionText.hide()


func _on_mission_text_visibility_changed() -> void:
	if %MissionText.visible:
		dim_mission_text()
