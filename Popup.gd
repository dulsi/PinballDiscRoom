extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func reset():
	$AnimatedSprite.animation = "down"
	$CollisionShape2D.disabled = true


func popup():
	$AnimatedSprite.animation = "default"
	$CollisionShape2D.disabled = false


func hit():
	$AnimatedSprite.animation = "down"
	$CollisionShape2D.set_deferred("disabled", true)
	get_parent().check_popups()
