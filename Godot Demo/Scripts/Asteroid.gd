extends RigidBody2D

signal on_asteroid_destroyed(score)

var destroyed: PackedScene
var hp setget set_hp
var speed_scale: = 1
var push_force
var lx
var isSelected: bool = false
var score: = int(rand_range(1, 3))

func set_hp(value):
	hp = value

func set_properties():
	if isSelected:
		$Collision2D.disabled = false
	randomize()
	mass = rand_range(8.5, 20.25)
	angular_velocity = rand_range(-5, 5)
	push_force = rand_range(100, 200)
	self.hp = int(rand_range(800, 1500))
	var s = rand_range(-0.3, 0.3)
	if s > 1.3:
		lx = rand_range(-300, -500)
	elif s >= 1 and s < 1.3:
		lx = rand_range(-900, -1200)
	else:
		lx = rand_range(-450, -910)
	linear_velocity = Vector2(lx - (120 * speed_scale), rand_range(-70, 70))
	
	$Sprite.scale += Vector2(s, s)
	$Collision2D.scale += Vector2(s, s)
	$VisibilityNotifier2D.scale += Vector2(s, s)

func receive_damage(damage):
	self.hp -= damage
	if hp <= 0:
		destroy()

func destroy():
	emit_signal("on_asteroid_destroyed", score)
	VfxManager.create_effect(destroyed, global_position)
	get_parent().queue_free()
