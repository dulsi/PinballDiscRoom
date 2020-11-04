extends Node

export (PackedScene) var Disc
var score
var default_room_filler = 2
var room_filler
var scoring = false
var paddles = ["PaddleBR1", "PaddleBR2", "PaddleBL1", "PaddleBL2", "PaddleTL1", "PaddleTL2", "PaddleTR1", "PaddleTR2"]
var secretPath = ["SecretPath"]
var gzilla = preload("res://gdgamerzillascript.gdns").new()

func _ready():
	randomize()
	if (gzilla):
		print(gzilla.start(false, OS.get_user_data_dir()))
		gzilla.setGameFromFile("res://gamerzilla/pinballdiscroom.game.tres", "")


func _process(delta):
	if scoring:
		var orig_score = score
		score += delta
		if orig_score < 2 && score >= 2:
			$Button2.animation = "lit"
		if orig_score < 5 && score >= 5:
			$Button5.animation = "lit"
		if orig_score < 7 && score >= 7:
			$Button7.animation = "lit"
		if orig_score < 10 && score >= 10:
			$Button10.animation = "lit"
			if (gzilla):
				gzilla.setTrophy("Survive 10")
		if orig_score < 15 && score >= 15:
			$Button15.animation = "lit"
		$HUD.update_score(score)

func game_over():
	scoring = false
	$StartTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Camera2D.shake = 6
	for _i in range(1, 12, 1):
		var blood = preload("res://Blood.tscn").instance()
		$Discs.add_child(blood)
		blood.position = $Player.position
		blood.get_node("Sprite").rotation += rand_range(0, 3.14 * 2)
		blood.linear_velocity = Vector2(rand_range(5, 150), 0)
		blood.linear_velocity = blood.linear_velocity.rotated(rand_range(0, 2 * PI))

func new_game():
	$DiscEjector.eject()
	score = 0.00
	room_filler = default_room_filler
	$MobTimer.wait_time = 1
	var discAry = $Discs.get_children()
	for item in discAry:
		$Discs.remove_child(item)
	$Player.start($StartPosition.position)
	$SecretPath.close()
	$PopupTimer.reset()
	$PopupTimer.start()
	$MobTimer.start()
	$Button2.animation = "unlit"
	$Button5.animation = "unlit"
	$Button7.animation = "unlit"
	$Button10.animation = "unlit"
	$Button15.animation = "unlit"
	$HUD.update_score(score)
	$HUD.hide_message()
	$Transporter.get_node("AnimatedSprite").play()
	$DiscPosition.get_node("Transporter").get_node("AnimatedSprite").play()


func _on_StartTimer_timeout():
	scoring = true


func _on_MobTimer_timeout():
	$DiscEjector.eject()
	if room_filler > 0:
		room_filler -= 1
		if room_filler == 0:
			$MobTimer.stop()
			$MobTimer.set_wait_time(2)
			$MobTimer.start()


func _on_DiscEjector_transport():
	if !scoring && $Player/AnimatedSprite.animation != "dead":
		scoring = true
	var disc = Disc.instance()
	$Discs.add_child(disc)
	disc.get_node("AnimatedSprite").play()
	disc.position = $DiscPosition.position


func _on_PaddleTimer_timeout():
	get_node(paddles[rand_range(0, paddles.size())]).trigger()
	


func _on_PopupTimer_popups_hit():
	$SecretPath.open()


func getOpenPaths():
	var answer = []
	for item in secretPath:
		if get_node(item).is_open:
			answer.push_back(get_node(item))
	return answer

func setSecretPassageTrophy():
	if (gzilla):
		gzilla.setTrophy("Safe Passage")
