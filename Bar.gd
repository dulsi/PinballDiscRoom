extends RigidBody2D


var base_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	base_rotation = get_rotation()


func open():
	rotation = base_rotation + PI / 2

func close():
	rotation = base_rotation

