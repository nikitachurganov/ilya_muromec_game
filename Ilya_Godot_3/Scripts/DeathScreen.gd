extends Control

func _ready():
	var button = $Button
	button.connect("pressed", self, "change_stage", [button.scene_to_open])

func change_stage(path):
	SceneChanger.change_scene(path)
