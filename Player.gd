extends KinematicBody2D
signal crash

# put this in globals later
var tile_size = 32

# Called when the node enters the scene tree for the first time.
func _ready():
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

# the following function SHOULD be unnecessary, because collisions should not occur
func _on_Area2D_body_entered(body):
	emit_signal("crash")
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
