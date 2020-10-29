extends Timer


signal popups_hit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func check_popups():
	var done = true
	for item in get_children():
		var spr = item.get_node("AnimatedSprite")
		if spr && spr.animation != "down":
				done = false
	if done:
		emit_signal("popups_hit")


func reset():
	for item in get_children():
		if item.has_method("reset"):
			item.reset()

func _on_PopupTimer_timeout():
	for item in get_children():
		if item.has_method("popup"):
			item.popup()
	$AudioStreamPlayer.play()
