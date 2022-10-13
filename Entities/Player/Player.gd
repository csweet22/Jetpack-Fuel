extends Character

class_name Player

onready var jump_vfx = $JumpParticles
onready var jump_sfx = $Audiostreams/JumpStream

onready var jetpack_vfx = $JetpackVFX/JetpackParticles
onready var jetpack_burst_sfx = $Audiostreams/JetStream
onready var jetpack_hover_sfx = $Audiostreams/HoverStream

onready var player_sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	jump_ray.set_cast_to(Vector2(0,JUMP_SPACE_BUFFER))


func _physics_process(delta):
	handle_jump_logic()
	handle_input()
	movement(delta)
	handle_jetpack_logic()
	ground_pound()
	move_and_slide(move_vec,Vector2.UP)
	

func handle_input():
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("jump") and not ground_pounding and not is_jetpacking:
		jump()
	
	if Input.is_action_just_pressed("shoot"): 
		shoot()
	
	if Input.is_action_just_pressed("pound"):
		if not ground_pounding:
			if not is_on_floor():
				ground_pounding = true

func movement(delta):
	$RunParticles.direction.x = -dir_facing * 5
	
	if Input.is_action_pressed("move_right") or Input.get_action_strength("controller_right") > 0.1:
		if Input.get_action_strength("controller_right") < 0.1:
			move_vec.x += ACCEL_X
		else:
			move_vec.x = MAX_SPEED_X * Input.get_action_strength("controller_right")
		dir_facing = 1
		player_sprite.flip_h = false
		player_sprite.position.x = -2
		if is_on_floor():
			$RunParticles.emitting = true
			player_sprite.animation = "Run"
			
	elif Input.is_action_pressed("move_left")  or Input.get_action_strength("controller_left") > 0.1:
		if Input.get_action_strength("controller_left") < 0.1:
			move_vec.x -= ACCEL_X
		else:
			move_vec.x = -MAX_SPEED_X * Input.get_action_strength("controller_left")
			
		dir_facing = -1
		player_sprite.flip_h = true
		player_sprite.position.x = 0
		if is_on_floor():
			$RunParticles.emitting = true
			player_sprite.animation = "Run"
	else:
		
		$RunParticles.emitting = false
		
		if is_on_floor():
			player_sprite.animation = "Idle"
	
	if not is_on_floor():
		$RunParticles.emitting = false
	
	if move_vec.x > MAX_SPEED_X:
		move_vec.x = MAX_SPEED_X
	elif move_vec.x < -MAX_SPEED_X:
		move_vec.x = -MAX_SPEED_X
		
	if not(Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and not(Input.get_action_strength("controller_left") > 0.1 or Input.get_action_strength("controller_right") > 0.1):
		var init_y = move_vec.y
		move_vec = move_vec.move_toward(Vector2.ZERO,DEACCEL*delta)
		move_vec = Vector2(move_vec.x,init_y)
		$Audiostreams/WalkStream.stop()
	else:
		if is_on_floor():
			if $Audiostreams/WalkStream.playing == false:
				$Audiostreams/WalkStream.play()	
		else:
			$Audiostreams/WalkStream.stop()

func jump():
	if can_jump:
		player_sprite.animation = "Jump"
		move_vec.y = -JUMP_FORCE
		
		if is_on_floor() or jump_ray.is_colliding():
			jump_vfx.restart()
			jump_sfx.play()
		else:
			# $JetpackParticles1.restart()
			# $JetpackParticles2.restart()
			jetpack_burst_sfx.play()
		can_jump = false

func handle_jump_logic():
	if is_on_floor():
		can_jump = true
		move_vec.y = 0
		# $JetpackParticles1.emitting = false
		# $JetpackParticles2.emitting = false
	elif jump_ray.is_colliding():
		if move_vec.y > 0:
			can_jump = true
	
	if not is_on_floor():
		if move_vec.y < MAX_GRAVITY_DOWN:
			move_vec.y += GRAVITY
	else:
		move_vec.y = 50
	
	if is_on_ceiling():
		move_vec.y = 1

func shoot():
	var bullet = Bullet.instance()
	bullet.init(dir_facing)
	var world = get_tree().current_scene
	world.add_child(bullet)
	bullet.global_position = global_position
	bullet.global_position.x += dir_facing * 3
	$Audiostreams/ShootStream.play()

func ground_pound():
	if ground_pounding and is_on_floor():
		$Audiostreams/PoundStream.play()
		$JumpParticles.restart()
	
	if is_on_floor():
		ground_pounding = false
	
	if ground_pounding:
		move_vec.y = POUND_SPEED

func handle_jetpack_logic():
	if not is_on_floor():
		if Input.is_action_pressed("jetpack"):
			can_jump = false
			move_vec.y -= 12
			is_jetpacking = true
			player_sprite.animation = "Jump"

			jetpack_vfx.emitting = true
			if jetpack_hover_sfx.playing == false:
				jetpack_hover_sfx.play()
		else:
			jetpack_hover_sfx.stop()
			is_jetpacking = false
			jetpack_vfx.emitting = false
	else:
		jetpack_vfx.emitting = false
		jetpack_hover_sfx.stop()
		is_jetpacking = false

