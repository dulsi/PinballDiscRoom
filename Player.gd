extends Area2D

signal hit

export var speed = 6
var screen_size = Vector2(320,320)
var push_velocity = Vector2(0,0)
var push_time = 0
var secretPath = null
var secretOffset = 0
var secretDirection = 1
var secretEnd = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func _process(delta):
	if Input.is_action_pressed("ui_focus_next"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if is_visible_in_tree() && $AnimatedSprite.animation != "dead":
		if secretPath:
			secretOffset += 400 * delta * secretDirection
			if secretDirection == -1 && secretOffset < 0:
				secretOffset = 0
			elif secretDirection == 1 && secretOffset >= secretEnd:
				secretOffset = secretEnd
			position = secretPath.curve.interpolate_baked(secretOffset)
			if secretOffset == secretEnd:
				secretPath.close()
				secretPath = null
				position.x = clamp(position.x, 0, screen_size.x)
				position.y = clamp(position.y, 0, screen_size.y)
		else:
			var velocity = Vector2()  # The player's movement vector.
			if Input.is_action_pressed("ui_right"):
				velocity.x += 400
			if Input.is_action_pressed("ui_left"):
				velocity.x -= 400
			if Input.is_action_pressed("ui_down"):
				velocity.y += 400
			if Input.is_action_pressed("ui_up"):
				velocity.y -= 400
			if velocity.x != 0 || velocity.y != 0:
				var angle = velocity.angle()
				$AnimatedSprite.set_rotation(angle + PI / 2)
			velocity += push_velocity
			push_time -= delta
			if push_time <= 0:
				push_time = 0
				push_velocity = Vector2(0,0)
			if velocity.length() > 0:
				#velocity = velocity.normalized() * speed
				$AnimatedSprite.animation = "walk"
				$AnimatedSprite.play()
			else:
				$AnimatedSprite.animation = "default"
				$AnimatedSprite.stop()
			position += velocity * delta
			var checkPaths = false
			if position.x < 0:
				checkPaths = true
				velocity.x = abs(velocity.x)
			elif position.x > screen_size.x:
				checkPaths = true
				velocity.x = -1 * velocity.x
			if position.y < 0:
				checkPaths = true
				velocity.y = abs(velocity.y)
			elif position.y > screen_size.y:
				checkPaths = true
				velocity.y = -1 * velocity.y
			position.x = clamp(position.x, 0, screen_size.x)
			position.y = clamp(position.y, 0, screen_size.y)
			if checkPaths:
				checkOpenPaths(position)


func _on_Player_body_entered(body):
	if body.has_method("damage"):
		$AnimatedSprite.animation = "dead"
		$DeathSound.random()
		$DeathSound.play()
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disabled", true)
	if body.has_method("push"):
		push_velocity = body.push()
		push_time = 0.25
	if body.has_method("hit"):
		body.hit()

func start(pos):
	position = pos
	push_velocity = Vector2(0,0)
	push_time = 0
	$AnimatedSprite.animation = "default"
	show()
	$CollisionShape2D.disabled = false

func checkOpenPaths(loc):
	var paths = get_parent().getOpenPaths()
	for item in paths:
		var closest = item.curve.get_closest_point(loc)
		if closest.distance_to(loc) < 20:
			secretPath = item
			secretOffset = item.curve.get_closest_offset(closest)
			if secretOffset == 0:
				secretDirection = 1
				secretEnd = item.curve.get_closest_offset(item.curve.get_point_position(item.curve.get_point_count() - 1))
			else:
				secretDirection = -1
				secretEnd = 0
			return
