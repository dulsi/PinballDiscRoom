extends RigidBody2D

var blood_img = ["blood1", "blood2", "blood3", "blood4", "blood5"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.animation = blood_img[rand_range(0,5)]
