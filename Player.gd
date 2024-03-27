extends Node3D

@export var kick_strength = 20
@export var kick_up_boost = 15

@onready var body: RigidBody3D = $Body
@onready var camera: PhantomCamera3D = $PhantomCamera3D

func _enter_tree():
    set_multiplayer_authority(str(name).to_int())

func _ready():
    if !is_multiplayer_authority(): return

func _physics_process(delta):
    if !is_multiplayer_authority(): return
