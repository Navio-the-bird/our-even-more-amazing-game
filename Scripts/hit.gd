extends Node2D


@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	anim.play("Hit")
	anim.animation_finished.connect(queue_free)
