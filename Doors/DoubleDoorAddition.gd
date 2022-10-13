extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Door_changed():
	$Sprite3.set_region_rect($Sprite2.get_region_rect())
