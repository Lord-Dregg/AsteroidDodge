extends KinematicBody2D

signal hit


export(float) var speed = 2500.0
export(float) var inertia = 0.05
export(float) var max_speed = 500.0
export(float) var MAX_HEALTH = 3.0
export(float) var bodyDamage = 120.0
export(int) var bulletPerShot: = 2 setget bpsIncrement

onready var firingTimer: = $FiringTimer

var spawnPoints = []
var velocity: = Vector2.ZERO
var health = MAX_HEALTH setget ,get_health
var canShoot: = true
var bulletScene: PackedScene

func bpsIncrement(value):
	bulletPerShot = value
	print(bulletPerShot)
	for spawnPoint in spawnPoints:
		if bulletPerShot == 1:
			if ("Single") in spawnPoint.name:
				spawnPoint.visible = true
			else:
				spawnPoint.visible = false
		if bulletPerShot == 2:
			if ("Double") in spawnPoint.name:
				spawnPoint.visible = true
			else:
				spawnPoint.visible = false
		if bulletPerShot == 3:
			if ("Triple") in spawnPoint.name:
				spawnPoint.visible = true
			else:
				spawnPoint.visible = false
		if bulletPerShot > 3:
			if ("Poly") in spawnPoint.name:
				spawnPoint.visible = true
			else:
				spawnPoint.visible = false

func get_health():
	var percent = int((health / MAX_HEALTH) * 100)
	return max(0, percent)

func _ready():
	for i in $FirePoints.get_children():
		spawnPoints.push_back(i)
	bpsIncrement(2)
	change_bullet(WeaponManager.selectedBullet)
	var b = bulletScene.instance()
	firingTimer.wait_time = b.firingRate

func _physics_process(delta):
	if Input.is_action_just_pressed("inc"):
		self.bulletPerShot += 1
	if Input.is_action_just_pressed("dec"):
		self.bulletPerShot -= 1
	shoot()
	if Input.is_action_pressed("right"):
		velocity.x += speed * delta
	elif Input.is_action_pressed("left"):
		velocity.x -= speed * delta
	else:
		velocity.x = lerp(velocity.x, 0, inertia)
	velocity.x = clamp(velocity.x, -max_speed*2, max_speed*2)
	
	if Input.is_action_pressed("up"):
		velocity.y -= speed * delta
	elif Input.is_action_pressed("down"):
		velocity.y += speed * delta
	else:
		velocity.y = lerp(velocity.y, 0, inertia)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	velocity = move_and_slide(velocity)
	if rotation_degrees != 0:
		rotation_degrees = lerp(rotation_degrees, 0, 0.4)

func knockback(dir: Vector2, force: float, torque: float):
	health -= 1.0
	emit_signal("hit")
	if health <= 0:
		queue_free()
	velocity = dir * force * 0.8
	
	rotation += torque
	$AnimationPlayer.play("invicibility")

func shoot():
	var b = bulletScene.instance()
	if b.fireMode == b.GUN_FIRE_MODE.AUTO:
		if Input.is_action_pressed("shoot") and canShoot and hasBullet():
			spawnBullet(b)
	elif b.fireMode == b.GUN_FIRE_MODE.ONESHOT:
		if Input.is_action_just_pressed("shoot") and canShoot and hasBullet():
			spawnBullet(b)

func spawnBullet(bullet):
	canShoot = false
	firingTimer.start()
	firingTimer.wait_time = bullet.firingRate
	
	for i in spawnPoints:
		if i.visible:
			var b = bulletScene.instance()
			b.global_position = i.global_position
			get_tree().current_scene.add_child(b)

func receive_damage(dmg):
	health -= dmg

func _on_FiringTimer_timeout():
	canShoot = true

func change_bullet(name: String):
	WeaponManager.selectedBullet = name
	bulletScene = WeaponManager.get_bullet(WeaponManager.selectedBullet)

func hasBullet() -> bool:
	return not WeaponManager.get_bullet(WeaponManager.selectedBullet) == null
