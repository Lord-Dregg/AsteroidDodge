extends Node

export(PackedScene) var destroyedEffect

var scale: = 1
var asteroid: RigidBody2D

func set_asteroid():
	var child_count = get_child_count()
	var index = randi() % child_count
	var scr = load("res://Scripts/Asteroid.gd")
	asteroid = get_child(index) as RigidBody2D
	asteroid.set_script(scr)
	asteroid.mode = RigidBody2D.MODE_RIGID
	asteroid.isSelected = true
	asteroid.set("visible", true)
	asteroid.speed_scale = scale
	asteroid.set_properties()

func _ready():
	randomize()
	set_asteroid()
	
	for i in get_children():
		if i is RigidBody2D and i.get_script():
			var _p = (i as RigidBody2D).connect("body_entered", self, "body_entered")
			var _q = ((i as RigidBody2D).get_node("VisibilityNotifier2D") as VisibilityNotifier2D).connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
			i.destroyed = destroyedEffect
			i.connect("on_asteroid_destroyed", get_tree().current_scene, "updateScore")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func body_entered(body):
	if body is KinematicBody2D:
		body.knockback(self.global_position.direction_to(body.global_position),asteroid.push_force, rand_range(-15, 15))
		asteroid.receive_damage(body.bodyDamage)
