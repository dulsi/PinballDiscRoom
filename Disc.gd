extends RigidBody2D

export var min_speed = 200  # Minimum speed range.
export var max_speed = 300  # Maximum speed range.
export var screen_size = Vector2(320,320)
export var appearing = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#screen_size = get_viewport_rect().size


func _process(delta):
	$AnimatedSprite.rotation -= 3.14 * delta
	if $AnimatedSprite.animation == "default":
		var bounced = false
		if position.x < 0 && linear_velocity.x < 0:
			bounced = true
			linear_velocity.x = abs(linear_velocity.x)
		elif position.x > screen_size.x && linear_velocity.x > 0:
			bounced = true
			linear_velocity.x = -1 * linear_velocity.x
		if position.y < 0 && linear_velocity.y < 0:
			bounced = true
			linear_velocity.y = abs(linear_velocity.y)
		elif position.y > screen_size.y && linear_velocity.y > 0:
			bounced = true
			linear_velocity.y = -1 * linear_velocity.y
		if bounced:
			var spark = preload("res://Spark.tscn").instance()
			get_parent().add_child(spark)
			spark.position = position
			spark.play()
			linear_velocity = linear_velocity.rotated(rand_range(-PI/36, PI/36))
		position.x = clamp(position.x, 0, screen_size.x - 1)
		position.y = clamp(position.y, 0, screen_size.y - 1)


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.animation = "default"
	$CollisionShape2D.disabled = false
	linear_velocity = Vector2(rand_range(min_speed, max_speed), 0)
	linear_velocity = linear_velocity.rotated(rand_range(0, 2 * PI))
	$SpawnSound.random()
	$SpawnSound.play()

func damage():
	return 1
	
