extends KinematicBody

var is_out_of_control = false

# Movement
const GRAVITY = -50.0

var velocity = Vector3.ZERO
var dir = Vector3.ZERO
var input_movement_vector = Vector2.ZERO

const SPEED = 15
const ACCEL = 10.0

const SPRINT_SPEED = 30
const SPRINT_ACCEL = 20.0
var is_sprinting = false

const JUMP_SPEED = 20
var jump_counter = 0

const MAX_SLOPE_ANGLE = 45

var camera = null
var rotation_helper = null
var MOUSE_SENSITIVITY = 0.1

# Wallrunning
var can_wall_run = false
var is_wall_running = false
var wall_normal = Vector3.ZERO
onready var wall_run_timer = $Timers/WallrunTimer

onready var wallrun_rotation_helper = $RotationHelper/WallRunRotationHelper
const WALL_RUN_ANGLE = 10
var wall_run_current_angle = 0
var wall_lerp_speed = 100.0
var side = ""

# Weapon Manager
var weapon_manager = null

# Health
onready var health = $RotationHelper/Health
var knocked_down = false

# References
onready var game_states = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("GameStates")

func _ready():
	rotation_helper = $RotationHelper
	camera = $RotationHelper/WallRunRotationHelper/Camera
	weapon_manager = $RotationHelper/Weapons
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide_interaction_prompt()
	health.decrease_health(0)



func _physics_process(delta):
	
	if is_out_of_control == false:
		process_movement_input()
		process_movement_logic(delta)
		process_weapon()
		
		if Input.is_action_just_pressed("ui_cancel"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	else:
		out_of_control(delta)


func process_movement_input():
	
	# Get Input Directions
	dir = Vector3.ZERO
	var cam_global = camera.global_transform
	
	input_movement_vector = Vector2.ZERO
	
	if Input.is_action_pressed("forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("right"):
		input_movement_vector.x += 1
	if Input.is_action_pressed("left"):
		input_movement_vector.x -= 1
	
	input_movement_vector = input_movement_vector.normalized()
	
	dir += -cam_global.basis.z * input_movement_vector.y
	dir += cam_global.basis.x * input_movement_vector.x
	
	# Sprinting Logic
	if input_movement_vector.y > 0:
		is_sprinting = Input.is_action_pressed("sprint")
	else:
		is_sprinting = false
	
	# Jump logic for handling various inputs and conditions
	jump_logic()

func jump_logic():
	# Reset jump counter and other properties when on floor
	if is_on_floor():
		jump_counter = 0
		can_wall_run = false
		is_wall_running = false
	
	# Jump while wallrunning
	if Input.is_action_just_pressed("jump") and is_wall_running:
		jump_counter = 0
		can_wall_run = false
		is_wall_running = false
	
	# Jump
	if Input.is_action_just_pressed("jump") and jump_counter < 2:
		jump_counter += 1
		velocity.y = JUMP_SPEED
		
		AudioManager.play_sound("Jump")
		
		# Enable wallrunning after a slight delay
		yield(get_tree().create_timer(0.2), "timeout")
		can_wall_run = true
		wall_run_timer.start()

func process_movement_logic(delta):
	
	# Apply Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	process_wallrun_movement()
	process_wallrun_rotation(delta)
	
	dir.y = 0
	dir = dir.normalized()
	
	var hvel = velocity
	hvel.y = 0
	
	# The target vector we will be aiming for
	var target = dir
	target *= get_speed()
	
	# Will be used as a factor for interpolating from current velocity to target velocity
	var accel = ACCEL if not is_sprinting else SPRINT_ACCEL
	
	hvel = hvel.linear_interpolate(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 10, deg2rad(MAX_SLOPE_ANGLE))



# Returns speed based on different conditions
func get_speed():
	if is_sprinting:
		return SPRINT_SPEED
	
	return SPEED

# Returns current kinematic velocity's magnitude, based on the player's forward direction
func get_forward_velocity_magnitude():
	var forward = global_transform.basis.z.normalized()
	var vel = velocity
	var dot = forward.dot(vel)
	
	return dot



# Not a setter for is_wall_running
func set_is_wall_running(value):
	if value == false:
		if is_wall_running == true:
			jump_counter = 0
	
	is_wall_running = value

# Logic for wallrunning
func process_wallrun_movement():
	if can_wall_run:
		if Input.is_action_pressed("sprint") and get_forward_velocity_magnitude() > 0.25:
			if Input.is_action_pressed("forward"):
				if is_on_wall():
					wall_normal = get_slide_collision(0).normal
					var point = get_slide_collision(0).position
					side = get_side(point)
					is_wall_running = true
					
					velocity.y = 0
					velocity += -wall_normal * SPRINT_SPEED
				else:
					set_is_wall_running(false)

# While wallrunning, which side the wall is
func get_side(point):
	point = to_local(point)
	
	if point.x < 0:
		return "RIGHT"
	elif point.x > 0:
		return "LEFT"
	else:
		return "CENTER"

# When wallrun time runs out
func _on_WallrunTimer_timeout():
	can_wall_run = false
	set_is_wall_running(false)

# For rotating camera while wallrunning
func process_wallrun_rotation(delta):
	var target_angle = 0
	
	if is_wall_running:
		target_angle = WALL_RUN_ANGLE if side == "LEFT" else -WALL_RUN_ANGLE
		
		if side == "LEFT":
			wall_run_current_angle += delta * wall_lerp_speed
			wall_run_current_angle = clamp(wall_run_current_angle, 0, target_angle)
		elif side == "RIGHT":
			wall_run_current_angle -= delta * wall_lerp_speed
			wall_run_current_angle = clamp(wall_run_current_angle, target_angle, 0)
	
	else:
		target_angle = 0
		
		if wall_run_current_angle > 0:
			wall_run_current_angle -= delta * wall_lerp_speed
			wall_run_current_angle = max(0, wall_run_current_angle)
		elif wall_run_current_angle < 0:
			wall_run_current_angle += delta * wall_lerp_speed
			wall_run_current_angle = min(wall_run_current_angle, 0)
	
	wallrun_rotation_helper.rotation_degrees = Vector3(0,0,1) * wall_run_current_angle



# For handling camera movements
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate rotation_helper(x) and player(y)
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		# Clamp camera's x-axis rotation
		var temp_rotation = rotation_helper.rotation_degrees
		temp_rotation.x = clamp(temp_rotation.x, -75, 75)
		rotation_helper.rotation_degrees = temp_rotation



# Weapon Handling
func process_weapon():
	if Input.is_action_just_pressed("unarmed"):
		weapon_manager.change_weapon("Unarmed")
	elif Input.is_action_just_pressed("pistol"):
		weapon_manager.change_weapon("Pistol")
	
	if Input.is_action_just_pressed("shoot"):
		weapon_manager.fire_start()
	if Input.is_action_just_released("shoot"):
		weapon_manager.fire_stop()
	
	if Input.is_action_just_pressed("reload"):
		weapon_manager.reload_start()
	if Input.is_action_just_released("reload"):
		weapon_manager.reload_stop()


# Damage
func bullet_hit(damage, _pos):
	health.decrease_health(damage)


# Knocked down
func farewell():
	is_out_of_control = true
	knocked_down = true
	$AnimationPlayer.play("Knocked_Down")
	$RotationHelper/Weapons.visible = false
	
	game_states.current_state = game_states.states["GameOver"]


# Respawn
func reincarnate():
	is_out_of_control = false
	
	health.reset_health()
	$RotationHelper/Weapons.visible = true
	knocked_down = false
	$AnimationPlayer.play("Active")


# Game Over or Game Won
func out_of_control(delta):
	velocity.x = 0.0
	velocity.z = 0.0
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector3.UP, true, 10, deg2rad(MAX_SLOPE_ANGLE))



# WIll be called from outside (eg. Door)
func show_interaction_prompt():
	if $HUD/InteractionPrompt.visible == false:
		$HUD/InteractionPrompt.visible = true

func hide_interaction_prompt():
	if $HUD/InteractionPrompt.visible == true:
		$HUD/InteractionPrompt.visible = false
