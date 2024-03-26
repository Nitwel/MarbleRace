extends Node3D

@export var kick_strength = 20
@export var kick_up_boost = 15

@onready var body: RigidBody3D = $Body
@onready var ball: RigidBody3D = $"/root/Main/Ball"
@onready var camera: Camera3D = $Node3D/Camera3D

func _enter_tree():
    set_multiplayer_authority(str(name).to_int())

func _ready():
    if !is_multiplayer_authority(): return

    camera.current = true

func _physics_process(delta):
    if !is_multiplayer_authority(): return

    if Input.is_action_just_pressed("kick"):
        var distance = (ball.global_position - body.global_position)

        if distance.length() > 2.2:
            return

        var direction = distance.normalized() * kick_strength
        direction.y = kick_up_boost

        body.apply_impulse( - direction * 0.4)

        ball.apply_impulse(direction)