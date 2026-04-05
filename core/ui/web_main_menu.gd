extends CanvasLayer

@onready var connection = $MarginContainer/Connection
@onready var lobby = $MarginContainer/Lobby

@onready var name_edit = $MarginContainer/Connection/NameEdit
@onready var room_edit = $MarginContainer/Connection/RoomEdit

@onready var player_label = $MarginContainer/Lobby/PlayerLabel

func _ready():
	connection.visible = true
	lobby.visible = false
	
	MultiplayerHandler.tube.session_joined.connect(_on_session_joined)

func _on_join_pressed():
	MultiplayerHandler.join_server(room_edit.text)

func _on_session_joined():
	MultiplayerHandler.set_peer_name.rpc(name_edit.text)
	player_label.text = name_edit.text
	connection.visible = false
	lobby.visible = true
