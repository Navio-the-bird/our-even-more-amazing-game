class_name TowerMarker
extends Node2D

@export var tower_position: Vector2
var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# WTF, isn't there an easier way...?
	# I hate this so much
	# It wouldn't even work properly until I added explicit types
	var viewport_size := get_viewport_rect().size
	var visible_world_size := viewport_size / camera.zoom
	var world_screen_center := camera.get_screen_center_position()
	
	var direction := tower_position - world_screen_center
	const margin = 250
	var max_x := visible_world_size.x/2 - margin
	var max_y := visible_world_size.y/2 - margin
	
	var scale_x:float = 1000000
	var scale_y:float = scale_x
	#Get closest scaling to nearest screen edge
	if (direction.x != 0): scale_x = max_x/direction.x
	if (direction.y != 0): scale_y = max_y/direction.y
		
	var scale :float = min(abs(scale_x), abs(scale_y))
	var new_pos = world_screen_center + direction *scale
	global_position = global_position.move_toward(new_pos, 50)


func _on_area_2d_area_entered(area: Area2D) -> void:
	return
	var parent = area.get_parent()
	if (parent is not TowerMarker): return
	var tparent := parent as TowerMarker
	
	if (!tparent.visible): return
	hide()
	tparent.scale *= 1.5


func _on_area_2d_area_exited(area: Area2D) -> void:
	return
	var parent = area.get_parent()
	if (parent is not TowerMarker): return
	var tparent := parent as TowerMarker
	
	if (!tparent.visible): return
	show()
	tparent.scale /= 1.5
	
