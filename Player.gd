extends Node2D

export var is_healthy = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_animation("default")
	is_healthy = true
	
func move_player():
	if is_healthy and (Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")): # if healthy, check for movement
	
		# next series of lines applies velocity from movement
		var velocity = Vector2()
		if Input.is_action_just_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_just_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_just_pressed("ui_up"):
			velocity.y -= 1
		if Input.is_action_just_pressed("ui_down"):
			velocity.y += 1
			
		var dest_coord = get_parent().world_to_map(position + velocity * get_parent().cell_size) # dest_coord stores the coordinates of the destination
		var dest_type = get_parent().get_cellv(dest_coord) # dest_type stores the tile id of the destination tile
		if velocity != Vector2(0,0):
			if dest_type == 1: # wall
				pass # no movement
			elif dest_type == 2: # spike
				deflate() # deflates player
			else:
				position += velocity * get_parent().cell_size # movement occurs!
				
func deflate(): # deflates player
	$AnimatedSprite.set_animation("deflated")
	is_healthy = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_player()