extends Node

@onready var tube: TubeClient = $TubeClient

@onready var canvas_layer = $CanvasLayer


@onready var is_desktop: bool = OS.has_feature("pc")

var players: Dictionary[int, String]

signal player_name_set(peer: int)
signal players_updated

func _ready():
	canvas_layer.visible = false
	
	tube.session_left.connect(_on_session_left)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func create_server():
	tube.create_session()

func leave_server():
	tube.leave_session()

func join_server(id: String):
	tube.join_session(id)

@rpc("any_peer", "call_local", "reliable")
func set_peer_name(user: String):
	var peer = multiplayer.get_remote_sender_id()
	players.set(peer, user)
	player_name_set.emit(peer)
	players_updated.emit()

@rpc("authority", "call_local", "reliable")
func set_players(dict: Dictionary[int, String]):
	players = dict
	players_updated.emit()

func get_server_id() -> String:
	return tube.session_id

func _on_peer_connected(id: int):
	if not multiplayer.is_server():
		return
	set_players.rpc_id(id, players)

func _on_peer_disconnected(id: int):
	if players.has(id):
		players.erase(id)
		players_updated.emit()

func _on_session_left():
	players.clear()
	if is_desktop:
		return
	canvas_layer.visible = true
	get_tree().paused = true

func _on_disconnected_close_pressed():
	get_tree().paused = false
	canvas_layer.visible = false
	get_tree().change_scene_to_file(Database.MAIN_SCENE_PATH)
