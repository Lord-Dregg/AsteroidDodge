extends Node

var bullets = {
	"LaserRed": preload("res://Scenes/Bullets/LaserRed.tscn")
}

func get_bullet(index: String) -> PackedScene:
	return bullets[index]

var selectedBullet: String = "LaserRed"
