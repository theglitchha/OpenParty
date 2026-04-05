extends CanvasLayer

@onready var game_label = $MarginContainer/Control/HBoxContainer/VBoxContainer/Label

@onready var room_code = $MarginContainer/Control/HBoxContainer/VBoxContainer2/HBoxContainer/RoomCode
@onready var player_container = $MarginContainer/Control/HBoxContainer/VBoxContainer2/ScrollContainer/PlayerContainer

func _ready():
	MultiplayerHandler.tube.session_created.connect(_on_session_created)
	MultiplayerHandler.player_name_set.connect(_on_player_name_set)

func create_player_label(peer: int):
	var inst = PlayerLabel.new()
	inst.name = str(peer)
	player_container.add_child(inst)
	inst.set_peer(peer)

func _on_create_server_pressed():
	MultiplayerHandler.create_server()

func _on_session_created():
	room_code.text = MultiplayerHandler.get_server_id()

func _on_player_name_set(peer: int):
	if player_container.get_node_or_null(str(peer)):
		return
	create_player_label(peer)

func _on_destroy_server_pressed():
	MultiplayerHandler.leave_server()
	room_code.text = ""

func _on_start_game_pressed():
	pass # Replace with function body.
