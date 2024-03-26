extends RigidBody3D

@export var speed = 0.4
@export var max_speed = 10

func _integrate_forces(state):
    if !get_parent().is_multiplayer_authority(): return

    var input: Vector2 = Input.get_vector("left", "right", "up", "down", 0.0)

    if input.length() < 0.1:
        return

    input = input.normalized() * speed

    state.linear_velocity += Vector3(input.x, 0, input.y)
    state.linear_velocity = state.linear_velocity.clamp(Vector3( - max_speed, -max_speed, -max_speed), Vector3(max_speed, max_speed, max_speed))