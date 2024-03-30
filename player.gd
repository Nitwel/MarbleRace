extends Node3D

@export var jump_strength = 10

@onready var body: RigidBody3D = $Body
@onready var camera = $Camera3D

func _enter_tree():
    set_multiplayer_authority(str(name).to_int())

func _ready():
    if !is_multiplayer_authority(): return

    camera.current = true

func _physics_process(delta):
    if !is_multiplayer_authority(): return