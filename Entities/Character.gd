extends KinematicBody2D

class_name Character

const MAX_SPEED_X := 170
const MAX_SPEED_Y := 350

const ACCEL_X := 200
const ACCEL_Y := 200
const DEACCEL := 6000

var current_x := 0
var current_y := 0

var move_vec := Vector2.ZERO

const JUMP_FORCE := 200
const JUMP_SPACE_BUFFER := 16
var can_jump := false
var jumping := false
onready var jump_ray := $RayCast2D


var is_jetpacking := false

var ground_pounding := false
var POUND_SPEED := 600

var GRAVITY := 8
const MAX_GRAVITY_DOWN := 350


onready var Bullet := load("res://Entities/Player/Bullet.tscn")
var dir_facing := 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_position() -> Vector2:
	return Vector2(current_x, current_y)

func get_move_vector() -> Vector2:
	return move_vec


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
