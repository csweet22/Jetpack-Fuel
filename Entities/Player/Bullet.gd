extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var direction_facing = 1

var move_var = Vector2.ZERO
var speed = 400

var direction

onready var BulletPoof = load("res://Entities/Player/BulletPoof.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(dir):
	direction = dir
	move_var.x = dir * speed
	if dir == -1:
		$Sprite2.flip_h = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(move_var)


func _on_Timer_timeout():
	poof()
	queue_free()




func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	poof()
	queue_free()
	
func poof():
	var poof = BulletPoof.instance()
	var world = get_tree().current_scene
	world.add_child(poof)
	poof.global_position = global_position
	poof.global_position.x += direction * 7
