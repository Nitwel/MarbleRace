extends Node3D

const Player = preload ("res://player.tscn")

@onready var join: Button = $CanvasLayer/Control/VBoxContainer/JoinButton
@onready var host: Button = $CanvasLayer/Control/VBoxContainer/HostButton
@onready var ip_input = $CanvasLayer/Control/VBoxContainer/LineEdit

@onready var ui = $CanvasLayer

var peer

func _ready():

    join.button_down.connect(func():
        peer=ENetMultiplayerPeer.new()
        peer.create_client(ip_input.text, 1234)
        multiplayer.multiplayer_peer=peer

        add_player(multiplayer.get_unique_id())
        ui.visible=false
    )

    host.button_down.connect(func():
        peer=ENetMultiplayerPeer.new()
        peer.create_server(1234, 32)
        multiplayer.multiplayer_peer=peer

        multiplayer.peer_connected.connect(func(id):
            add_player(id)
        )

        add_player(multiplayer.get_unique_id())
        ui.visible=false
    )

func add_player(peer_id):
    var player = Player.instantiate()
    player.name = str(peer_id)
    add_child(player)