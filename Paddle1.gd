extends RigidBody2D

var state = 0

# The flipper takes this long to traverse its arc.
export var snap_time = 0.25

# The flipper's arc is this big, in degrees.
export var snap_angle = -50

var intermediate_time = 0.0
var base_rotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	base_rotation = get_rotation_degrees()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state == 1:
		if intermediate_time < snap_time:
			intermediate_time += delta
			if intermediate_time > snap_time:
				intermediate_time = snap_time
			set_rotation_degrees(base_rotation + (intermediate_time / snap_time) * snap_angle)
		else:
			state = 2
	elif state == 2:
		if intermediate_time > 0:
			intermediate_time -= delta
			if intermediate_time < 0:
				intermediate_time = 0
			set_rotation_degrees(base_rotation + (intermediate_time / snap_time) * snap_angle)
		else:
			state = 0

func push():
	var vel = Vector2(0, 600)
	if get_rotation_degrees() - base_rotation == 0:
		vel = Vector2(0, 0)
	return vel.rotated(rotation + PI)

func trigger():
	state = 1
