extends KinematicBody2D
signal player_moved

# put this in globals later
var tile_size = 32

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_animation("default")
	pass # Replace with function body.
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_just_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_just_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		velocity.y += 1
	# only move if there is velocity, and if a collision would not occur
	if velocity != Vector2(0,0) and not test_move(Transform2D(0.0,position),velocity*tile_size):
		position += velocity * tile_size
		emit_signal("player_moved")