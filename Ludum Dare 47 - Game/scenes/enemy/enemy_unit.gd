extends KinematicBody

# Reference to player
var player = null
var hit_arc = null

# Dictionary of states and a variable containing the current state
var states = {}
var current_state = null

# Whether enemy should chase player or stay stationary and attack
export var stationary = false

# Movement related variables
const GRAVITY = -50.0
var speed = 0
const ACCEL = 15.0

var velocity = Vector3.ZERO
var dir = Vector3.ZERO

# Distance for attacking and chasing
const CHASE_DISTANCE = 15
const ATTACK_DISTANCE = 5
const STATIONARY_ATTACK_DISTANCE = 25

# Reference to animation player of enemy
var animation

# Waypoints for patrolling state (will be initialized at the start of the game only)
var waypoints = []

# True when player falls into the detection area
# False when player leaves off the enemy far away
var detected = false

# For rotation of the chest when aiming
var skeleton
var chest_bone
var chest_bone_default_T

# For shooting
onready var ray = $"Enemy/Enemy/Skeleton 2/CenterRaycast/RayCast"
onready var muzzle_flash = $"Enemy/Enemy/Skeleton 2/BoneAttachment/Pistol/Skeleton/FireAttachment/MuzzleFlash"

# Health
const MAX_HEALTH = 100
var health = 100

func _ready():
	player = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Player")
	hit_arc = $HitArc
	hit_arc.set_enemy(self)
	
	states = {
		"Patrol" : $States/Patrol,
		"Idle" : $States/Idle,
		"Chase" : $States/Chase,
		"Attack" : $States/Attack
	}
	
	current_state = states["Patrol"]
	animation = $Enemy/AnimationPlayer
	
	# Happens only once during start of the game
	setup_waypoints()
	
	# Reference to the skeleton and chest bone
	skeleton = $"Enemy/Enemy/Skeleton 2"
	chest_bone = skeleton.find_bone("chest")
	chest_bone_default_T = skeleton.get_bone_pose(chest_bone)



func _physics_process(delta):
	current_state = current_state.process_states(delta)
	process_movement(delta)


func process_movement(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	var hvel = velocity
	hvel.y = 0
	
	dir.y = 0
	dir = dir.normalized()
	var target = dir * speed
	
	hvel = hvel.linear_interpolate(target, ACCEL * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	velocity = move_and_slide(velocity, Vector3.UP)


# Will be called only once
func setup_waypoints():
	var points = $Waypoints
	for p in points.get_children():
		waypoints.append(p.global_transform.origin)


# Looks at target location
func look_at_target(target):
	target = Vector3(target.x, global_transform.origin.y, target.z)
	look_at(target, Vector3.UP)


# Gets player location with the y being w.r.t enemy's y coordinate
func get_player_pos():
	return Vector3(player.global_transform.origin.x,
				   global_transform.origin.y,
				   player.global_transform.origin.z)


# Gets distance to player
func get_distance_to_player():
	return global_transform.origin.distance_to(get_player_pos())


# Chest rotation while aiming
func chest_look():
	var chest_T = skeleton.get_bone_pose(chest_bone)
	var chest_attachment = $"Enemy/Enemy/Skeleton 2/ChestAttachment"
	
	var normal = global_transform.basis.x
	var distance = normal.dot(chest_attachment.global_transform.origin)
	var plane = Plane(normal, distance)
	
	var chest_diff = chest_attachment.global_transform.origin - global_transform.origin
	var player_pos_adjusted = Vector3(player.global_transform.origin.x,
									  player.global_transform.origin.y + chest_diff.y,
									  player.global_transform.origin.z)
	
	var player_pos_proj = plane.project(player_pos_adjusted)
	var player_dir = player_pos_proj - chest_attachment.global_transform.origin
	var forward_dir = -self.global_transform.basis.z
	var angle = forward_dir.angle_to(player_dir)
	
	if player_pos_adjusted.y > chest_attachment.global_transform.origin.y:
		angle = -angle
	
	chest_T = chest_bone_default_T.rotated(Vector3.RIGHT, angle)
	
	skeleton.set_bone_pose(chest_bone, chest_T)



func _on_DetectionArea_body_entered(body):
	if body.get_name() == "Player":
		if body.is_out_of_control == false:
			detected = true


func _on_DetectionArea_body_exited(body):
	if body.get_name() == "Player":
		if body.is_out_of_control == false:
			detected = false


# Will be called by enemy's shooting animation
func shoot():
	muzzle_flash.emitting = true
	
	ray.force_raycast_update()
	AudioManager.play_sound("Shoot")
	
	if ray.is_colliding():
		var body = ray.get_collider()
		
		if body.has_method("bullet_hit"):
			body.bullet_hit(10, ray.global_transform)
			
			if body == player:
				hit_arc.show = true


# Damage
func bullet_hit(damage, bullet_pos):
	detected = true
	health -= damage
	
	if health <= 0:
		set_physics_process(false)
		death_animation(bullet_pos)
		$CollisionShape.disabled = true
		
		yield(get_tree().create_timer(5.0), "timeout")
		queue_free()


# Death Animation
func death_animation(bullet_pos):
	var bullet_dir = (global_transform.origin - bullet_pos).normalized()
	var forward_dir = global_transform.basis.z
	var angle = forward_dir.angle_to(bullet_dir)
	angle = rad2deg(angle)
	
	var normal = global_transform.basis.x
	var distance = normal.dot(global_transform.origin)
	var plane = Plane(normal, distance)
	
	var side = plane.is_point_over(bullet_pos)
	
	if angle <= 45:
		animation.play("Death_Front", -1.0, 2.0)
	elif angle > 45 and angle <= 135:
		if side:
			animation.play("Death_Right", -1.0, 2.0)
		else:
			animation.play("Death_Left", -1.0, 2.0)
	else:
		animation.play("Death_Back", -1.0, 2.0)
