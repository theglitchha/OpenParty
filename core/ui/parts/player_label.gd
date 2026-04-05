class_name PlayerLabel
extends Label

var peer_id: int

func _init():
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _ready():
	MultiplayerHandler.players_updated.connect(_on_players_updated)

func set_peer(id: int):
	peer_id = id
	_on_players_updated()

func _on_players_updated():
	if not MultiplayerHandler.players.has(peer_id):
		queue_free()
		return
	text = MultiplayerHandler.players.get(peer_id)
