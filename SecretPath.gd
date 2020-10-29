extends Path2D


export var is_open = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func open():
	for item in get_children():
		if item.has_method("open"):
			item.open()
	is_open = true
	$AudioStreamPlayer.play()

func close():
	for item in get_children():
		if item.has_method("close"):
			item.close()
	is_open = false
