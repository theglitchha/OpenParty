extends Node

@export var desktop_scene: PackedScene
@export var web_scene: PackedScene

func _ready():
	await get_tree().process_frame
	if OS.has_feature("pc"):
		get_tree().change_scene_to_packed(desktop_scene)
		return
	get_tree().change_scene_to_packed(web_scene)
