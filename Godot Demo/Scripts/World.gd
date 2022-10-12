extends Node2D

export(NodePath) var LEVEL_LABEL
export(NodePath) var TIME_LABEL
export(NodePath) var HEALTH_LABEL
export(NodePath) var SCORE_LABEL
export(NodePath) var PLAYER

export(Array, NodePath) var SPAWNPOINTS

onready var player: KinematicBody2D = get_node(PLAYER)
onready var sp1: = $SpawnPoint
onready var sp2: = $SpawnPoint2
onready var sp3: = $SpawnPoint3
onready var sp4: = $SpawnPoint4
onready var sp5: = $SpawnPoint5
onready var bgAnimPlayer: = $BGAnimationPlayer as AnimationPlayer
onready var bgScrollSpeed: = bgAnimPlayer.playback_speed

var spawnTimer: = Timer.new()
var spawnTimer2: = Timer.new()
var spawnTimer3: = Timer.new()
var spawnTimer4: = Timer.new()
var spawnTimer5: = Timer.new()
var levelTimer: = Timer.new()
var gameTimer: = Timer.new()
var level: = 1
var time: = 0
var score: int = 0 setget updateScore

func _ready():
	randomize()
	$CanvasLayer/Control/Buttons.visible = false
	var _h = player.connect("hit", self, "updateHealth")
	updateLevel()
	updateHealth()
	updateTime()
	updateScore(score)
	
	gameTimer.wait_time = 1
	gameTimer.autostart = true
	var _g = gameTimer.connect("timeout", self, "incrementTime")
	add_child(gameTimer)
	
	spawnTimer.wait_time = rand_range(0.75, 1.25)
	spawnTimer.autostart = true
	var _p = spawnTimer.connect("timeout", self, "spawn")
	add_child(spawnTimer)
	
	spawnTimer2.wait_time = rand_range(1.0, 1.8)
	spawnTimer2.autostart = true
	var _q = spawnTimer2.connect("timeout", self, "spawn")
	add_child(spawnTimer2)
	
	spawnTimer3.wait_time = rand_range(2.5, 3.7)
	spawnTimer3.autostart = true
	var _r = spawnTimer3.connect("timeout", self, "spawn")
	add_child(spawnTimer3)
	
	levelTimer.wait_time = rand_range(35, 45)
	levelTimer.autostart = true
	var _u = levelTimer.connect("timeout", self, "levelUP")
	add_child(levelTimer)

func spawn():
	var factory = preload("res://Scenes/AsteroidFactory.tscn").instance()
	factory.scale = level
	var sp = int(rand_range(1, SPAWNPOINTS.size()))
	var s = get_node(SPAWNPOINTS[sp])
	factory.global_position = s.global_position
	add_child(factory)

func levelUP():
	level += 1
	if level == 3:
		spawnTimer4.wait_time = rand_range(2.0, 3.0)
		spawnTimer4.autostart = false
		var _s = spawnTimer4.connect("timeout", self, "spawn")
		add_child(spawnTimer4)
		spawnTimer4.start()
	if level == 5:
		spawnTimer5.wait_time = rand_range(5.0, 7.25)
		spawnTimer5.autostart = false
		var _t = spawnTimer5.connect("timeout", self, "spawn")
		add_child(spawnTimer5)
		spawnTimer5.start()
	spawnTimer.wait_time -= (0.1 * level)
	spawnTimer2.wait_time -= (0.1 * level)
	spawnTimer3.wait_time -= (0.1 * level)
	spawnTimer4.wait_time -= (0.1 * level)
	spawnTimer5.wait_time -= (0.1 * level)
	
	bgScrollSpeed += 0.08

func updateLevel():
	(get_node(LEVEL_LABEL) as Label).text = "Level: " + str(level)

func incrementTime():
	time += 1
	updateTime()

func updateHealth():
	(get_node(HEALTH_LABEL) as Label).text = "Health: " + str(player.health) + "%"
	
	if player.health <= 0:
		Playerdata.previousScore = score
		Playerdata.highscore = int(max(score, Playerdata.highscore))
		$AnimationPlayer.play("game_over")
		get_tree().paused = true

func updateTime():
	(get_node(TIME_LABEL) as Label).text = "Time: " + str(time)

func updateScore(value):
	score += value
	(get_node(SCORE_LABEL) as Label).text = "Score: " + str(score)

func _on_RetryButton_pressed():
	yield(get_tree().create_timer(0.7), "timeout")
	var _r = get_tree().reload_current_scene()
	get_tree().paused = false


func _on_MainMenuButton_pressed():
	yield(get_tree().create_timer(0.7), "timeout")
	var _m = get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _process(delta):
	player.global_position.x = clamp(player.global_position.x, $Node2D/InvisibleWall.global_position.x, $Node2D/InvisibleWall2.global_position.x)
	if bgAnimPlayer.playback_speed != bgScrollSpeed:
		bgAnimPlayer.playback_speed = lerp(bgAnimPlayer.playback_speed, bgScrollSpeed, delta * 100)
