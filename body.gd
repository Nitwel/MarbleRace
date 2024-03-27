extends RigidBody3D

@export var speed = 0.4
@export var max_speed = 10

@onready var camera = $"../PhantomCamera3D"
@onready var look_target = $"../CameraLookTarget"

func _ready():
	var existing_path = get_node("/root/Main/Map/Path3D")

	var new_path = Path3D.new()
	new_path.curve = existing_path.curve.duplicate()
	new_path.position = Vector3(0, 4, 0)
	existing_path.get_parent().add_child(new_path)
	camera.set_follow_path(new_path)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if !get_parent().is_multiplayer_authority(): return

	var path: Path3D = get_node("/root/Main/Map/Path3D")
	var target_offset = path.curve.get_closest_offset(path.to_local(global_position))
	target_offset = fmod(target_offset + 4.0, path.curve.get_baked_length())

	var target = path.curve.sample_baked(target_offset)

	look_target.global_position = path.to_global(target) + Vector3(0, 1.5, 0)

	var input: Vector2 = Input.get_vector("left", "right", "up", "down", 0.0)

	if input.length() < 0.1:
		return

	input = input.rotated( - camera.global_rotation.y).normalized() * speed

	state.linear_velocity += Vector3(input.x, 0, input.y)
	state.linear_velocity = state.linear_velocity.clamp(Vector3( - max_speed, -max_speed, -max_speed), Vector3(max_speed, max_speed, max_speed))
