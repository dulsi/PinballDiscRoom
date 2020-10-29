extends Node2D


signal transport

var waitStart = 0.2
var waitRemain = 0
var state = 0
var maxPull = 50
var pullSpeed = 0.2
var releaseSpeed = 0.05
var disc = null


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_disc()


func _physics_process(delta):
	var y = $Plunger.get_position().y
	var y2 = 0
	if disc:
		y2 = disc.get_position().y
	if state == 1:
		y += maxPull / pullSpeed * delta
		y2 += maxPull / pullSpeed * delta
		if y > maxPull:
			y2 -= y - maxPull
			y = maxPull
		$Plunger.set_position(Vector2(0, y))
		if disc:
			disc.set_position(Vector2(0, y2))
		if y == maxPull:
			state = 2
			waitRemain = waitStart
	elif state == 2:
		waitRemain -= delta
		if waitRemain <= 0:
			state = 3
	elif state == 3:
		y -= maxPull / releaseSpeed * delta
		y2 -= maxPull / releaseSpeed * delta
		if y <= 0:
			y2 += y
			y = 0
			state = 0
			if disc:
				disc.controlled = false
				disc.set_position(Vector2(0, y2))
				disc = null
				state = 4
		$Plunger.set_position(Vector2(0, y))
		if disc:
			disc.set_position(Vector2(0, y2))
	elif state == 4:
		waitRemain -= delta
		if waitRemain <= 0:
			state = 0
			setup_disc()

func eject():
	state = 1

func forward_transport():
	emit_signal("transport")

func disc_ready():
	state = 5

func setup_disc():
	disc = preload("res://StartDisc.tscn").instance()
	add_child(disc)
	disc.set_position(Vector2(0,-78))
	disc.get_node("AnimatedSprite").play("disappear", true)
	disc.connect("transport_in", self, "disc_ready")
	disc.connect("transport", self, "forward_transport")
