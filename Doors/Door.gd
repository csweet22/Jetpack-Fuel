extends Node2D


const IDLE_DURATION = 1.0

export var open_pos = Vector2(0,-18)
export var speed = 100 

export var door_color = 0

onready var door = $object

var moving_towards_open = false
var emitted_up = false
var emitted_down = true

signal changed

func _ready():
	var sp2 = $object/Sprite2
	sp2.set_region_rect(Rect2(sp2.get_region_rect().position.x + 8 * door_color, sp2.get_region_rect().position.y, sp2.get_region_rect().size.x, sp2.get_region_rect().size.y))
	emit_signal("changed")
	

func _physics_process(delta):
	if moving_towards_open:
		door.position = door.position.move_toward(open_pos,delta * speed)
		
		emitted_down = false
		
		if abs(door.position.y - open_pos.y) <= 1 and emitted_up == false:
			#var node = get_tree().get_root().get_node("Main/ShakeCamera2D")
			var node = get_tree().get_root().get_node("Main/RoomAreas/ShakeCamera2D")
			node.add_trauma(0.2)
			$Open.play()
			emitted_up = true
		
	else:
		if door.position != Vector2.ZERO:
			door.position = door.position.move_toward(Vector2.ZERO,delta * speed)
			
			emitted_up = false
				
			if abs(door.position.y - open_pos.y) >= 23 and emitted_down == false:
				var node = get_tree().get_root().get_node("Main/RoomAreas/ShakeCamera2D")
				node.add_trauma(0.2)
				$Close.play()
				emitted_down = true
		


func _on_Area2D_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		moving_towards_open = true
	

func _on_Area2D_body_exited(body):
	
	if body in get_tree().get_nodes_in_group("Player"):
		moving_towards_open = false

