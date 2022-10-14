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
	pass

func _process(delta):
	handle_input()

func _physics_process(delta):

	print(can_jump, move_vec)

	apply_gravity()

	check_on_floor()
	check_on_ceiling()

	movement(delta)
	move_and_slide(move_vec,Vector2.UP)
	

func handle_input():
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("jump"):
		start_jump()
	
	if Input.is_action_just_pressed("shoot"): 
		shoot()
	
	if Input.is_action_just_pressed("pound"):
		start_ground_pound()
	
	if Input.is_action_pressed("jetpack"):
		start_jetpack()
	else:
		turn_off_jetpack_effects()
		
func check_on_floor():
	if is_on_floor():
		end_jump()
		end_ground_pound()
		end_jetpack()

func check_on_ceiling():
	if is_on_ceiling():
		move_vec.y = 1

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
		if is_on_floor() and not in_air:
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
		if is_on_floor() and not in_air:
			$RunParticles.emitting = true
			player_sprite.animation = "Run"
	else:
		
		$RunParticles.emitting = false
		
		if is_on_floor() and not in_air:
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

func start_jump():
	if not is_ground_pounding and not is_jetpacking and can_jump:
		jump()

func jump():

	in_air = true
	can_jump = false

	player_sprite.animation = "Jump"
	move_vec.y = -JUMP_FORCE

	if is_on_floor():
		jump_vfx.restart()
		jump_sfx.play()
	else:
		# $JetpackParticles1.restart()
		# $JetpackParticles2.restart()
		jetpack_burst_sfx.play()

func end_jump():
	if in_air and move_vec.y > 0:
		can_jump = true
		move_vec.y = 0
		in_air = false

func apply_gravity():
	if not is_on_floor():
		if move_vec.y < MAX_GRAVITY_DOWN:
			move_vec.y += GRAVITY

func shoot():
	var bullet = Bullet.instance()
	bullet.init(dir_facing)
	var world = get_tree().current_scene
	world.add_child(bullet)
	bullet.global_position = global_position
	bullet.global_position.x += dir_facing * 3
	$Audiostreams/ShootStream.play()

func start_ground_pound():
	if not is_ground_pounding and not is_on_floor():
		is_ground_pounding = true
		ground_pound()

func ground_pound():
	move_vec.y += POUND_SPEED

func end_ground_pound():
	if is_ground_pounding:
		is_ground_pounding = false
		$Audiostreams/PoundStream.play()
		$JumpParticles.restart()

func start_jetpack():
	if not is_on_floor():
		jetpack_propel()

func jetpack_propel():

	can_jump = false
	in_air = true
			
	move_vec.y -= 12
	is_jetpacking = true

	player_sprite.animation = "Jump"

	jetpack_vfx.emitting = true
	if jetpack_hover_sfx.playing == false:
		jetpack_hover_sfx.play()

func turn_off_jetpack_effects():
	jetpack_vfx.emitting = false
	jetpack_hover_sfx.stop()

func end_jetpack():
	if is_jetpacking:
		is_jetpacking = false
		turn_off_jetpack_effects()
		end_jump()
