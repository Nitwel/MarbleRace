extends RigidBody3D

var speed = 30
var jumping = false
var in_air = false

var jump_strength = 10

@onready var camera = $"../PhantomCamera3D"
@onready var test = $"../test"
@onready var test2 = $"../test2"
@onready var ground_ray = $"../FixedPos/RayCast3D"

func _ready():
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if !get_parent().is_multiplayer_authority(): return
	
	if in_air&&ground_ray.is_colliding():
		jumping = false

	in_air = !ground_ray.is_colliding()

	var path = get_node("/root/Main/Map/Path3D")
	var closest_offset = path.curve.get_closest_offset(path.to_local(global_position))

	var up = path.to_global(path.curve.sample_baked_up_vector(closest_offset, true))

	ground_ray.target_position = up * - 0.75

	# if !in_air&&!jumping:
	# 	var collision_point = ground_ray.get_collision_point()

	# 	var delta = global_position - collision_point

	# 	state.transform.origin -= delta - delta.normalized() * 0.58
	# 	gravity_scale = 0
	# else:
	# 	gravity_scale = 1
	
	if Input.is_action_just_pressed("jump")&&!in_air:
		apply_impulse(Vector3(up * jump_strength))
		jumping = true

	var input: Vector2 = Input.get_vector("left", "right", "up", "down", 0.0)

	var camera_pull_point = global_position + up.normalized() * 4

	var camera_pull = camera.global_position - camera_pull_point

	if camera_pull.length() > 6:
		camera.global_position = camera_pull_point + camera_pull.normalized() * 6

	if input.length() < 0.1:
		return

	input = input.rotated( - camera.global_rotation.y).normalized() * speed

	test.global_position = global_position + Vector3(input.x, 0, input.y) * 4
	test2.global_position = global_position + state.linear_velocity / 4

	state.linear_velocity += Vector3(input.x, 0, input.y) * state.step
