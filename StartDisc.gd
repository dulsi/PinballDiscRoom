extends RigidBody2D


signal transport_in
signal transport

export var controlled = true
var maxPull = 50
var releaseSpeed = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite.rotation -= 3.14 * delta
	if !controlled:
		var y = get_position().y
		y -= maxPull / releaseSpeed * delta
		if y <= -290:
			y = -290
		set_position(Vector2(get_position().x, y))
		if y == -290:
			emit_signal("transport")
			$AnimatedSprite.animation = "disappear"
			$AnimatedSprite.play()
			controlled = true


func _on_AnimatedSprite_animation_finished():
	if get_position().y == -290:
		queue_free()
	else:
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.stop()
		emit_signal("transport_in")
