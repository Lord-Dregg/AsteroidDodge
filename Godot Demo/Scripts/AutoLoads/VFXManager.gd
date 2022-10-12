extends Node

func create_effect(scene: PackedScene, position: Vector2):
	var e = scene.instance()
	e.global_position = position
	get_tree().current_scene.add_child(e)
