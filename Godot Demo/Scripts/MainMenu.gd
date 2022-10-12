extends Control

func _ready():
	get_tree().paused = false
	$Button.visible = true
	$AnimationPlayer.play("title_intro")
	$HighScore.text = "High Score: " + str(Playerdata.highscore)
	$PreviousScore.text = "Previous Score: " + str(Playerdata.previousScore)

func _on_Button_pressed():
	yield(get_tree().create_timer(0.7), "timeout")
	var _s = get_tree().change_scene("res://Scenes/World.tscn")

func startSubLabelAnim():
	$AnimationPlayer.play("sublabel")
