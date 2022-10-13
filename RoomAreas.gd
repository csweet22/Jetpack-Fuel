extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var enabled = true

export var Redleft = 0
export var Redtop = 0
export var Redright = 0
export var Redbottom = 0

export var Conleft = 0
export var Contop = 0
export var Conright = 0
export var Conbottom = 0

export var Graleft = 0
export var Gratop = 0
export var Graright = 0
export var Grabottom = 0
#
export var Orgleft = 0
export var Orgtop = 0
export var Orgright = 0
export var Orgbottom = 0
#
export var Golleft = 0
export var Goltop = 0
export var Golright = 0
export var Golbottom = 0

export var Gol2left = 0
export var Gol2top = 0
export var Gol2right = 0
export var Gol2bottom = 0
#export var left = 0
#export var top = 0
#export var right = 0
#export var bottom = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("lock_cam"):
		if enabled == true:
			enabled = false
		else:
			enabled = true
	if enabled == false:
		$ShakeCamera2D.limit_left = -1000000
		$ShakeCamera2D.limit_top = -10000000
		$ShakeCamera2D.limit_right = 10000000000
		$ShakeCamera2D.limit_bottom = 1000000000


func _on_RedRoom_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player") and enabled:
		$ShakeCamera2D.limit_left = Redleft
		$ShakeCamera2D.limit_top = Redtop
		$ShakeCamera2D.limit_right = Redright
		$ShakeCamera2D.limit_bottom = Redbottom


func _on_ConnectRoom_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player") and enabled:
		$ShakeCamera2D.limit_left = Conleft
		$ShakeCamera2D.limit_top = Contop
		$ShakeCamera2D.limit_right = Conright
		$ShakeCamera2D.limit_bottom = Conbottom


func _on_GrassRoom_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player") and enabled:
		$ShakeCamera2D.limit_left = Graleft
		$ShakeCamera2D.limit_top = Gratop
		$ShakeCamera2D.limit_right = Graright
		$ShakeCamera2D.limit_bottom = Grabottom
		
#
#	if body in get_tree().get_nodes_in_group("Player"):
#		$ShakeCamera2D.limit_left = left
#		$ShakeCamera2D.limit_top = top
#		$ShakeCamera2D.limit_right = right
#		$ShakeCamera2D.limit_bottom = bottom


func _on_OrangeRoom_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player") and enabled:
		$ShakeCamera2D.limit_left = Orgleft
		$ShakeCamera2D.limit_top = Orgtop
		$ShakeCamera2D.limit_right = Orgright
		$ShakeCamera2D.limit_bottom = Orgbottom


func _on_GoldRoom_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player") and enabled:
		$ShakeCamera2D.limit_left = Golleft
		$ShakeCamera2D.limit_top = Goltop
		$ShakeCamera2D.limit_right = Golright
		$ShakeCamera2D.limit_bottom = Golbottom



func _on_Gold2Room_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player") and enabled:
		$ShakeCamera2D.limit_left = Gol2left
		$ShakeCamera2D.limit_top = Gol2top
		$ShakeCamera2D.limit_right = Gol2right
		$ShakeCamera2D.limit_bottom = Gol2bottom
