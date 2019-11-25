extends Node2D

export var is_healthy = true

enum {UP, DOWN, LEFT, RIGHT}
var last_dir # last movement direction

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_animation("horizontal")
	is_healthy = true
	
func move_player():
	if is_healthy and (Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")): # if healthy, check for movement
		
		# next series of lines applies direction of movement
		var direction_vec = Vector2() # movement direction vector
		if Input.is_action_just_pressed("ui_right"):
			direction_vec.x += 1
			last_dir = RIGHT
		elif Input.is_action_just_pressed("ui_left"):
			direction_vec.x -= 1
			last_dir = LEFT
		elif Input.is_action_just_pressed("ui_up"):
			direction_vec.y -= 1
			last_dir = UP
		elif Input.is_action_just_pressed("ui_down"):
			direction_vec.y += 1
			last_dir = DOWN
		
		# following lines animate the player
		match last_dir:
			RIGHT:
				$AnimatedSprite.set_animation("horizontal") # set to horizontal animation
				$AnimatedSprite.set_frame(0) # reset frame to first
				$AnimatedSprite.play("",false) # play in forward direction
			LEFT:
				$AnimatedSprite.set_animation("horizontal") # set to horizontal animation
				$AnimatedSprite.set_frame(3) # reset frame to last
				$AnimatedSprite.play("",true) # play in reverse direction
			UP:
				$AnimatedSprite.set_animation("vertical") # set to vertical animation
				$AnimatedSprite.set_frame(0) # reset frame to first
				$AnimatedSprite.play("",false) # play in forward direction
			DOWN:
				$AnimatedSprite.set_animation("vertical") # set to vertical animation
				$AnimatedSprite.set_frame(3) # reset frame to last
				$AnimatedSprite.play("",true) # play in reverse direction
			
		var dest_coord = get_parent().world_to_map(position) + direction_vec # dest_coord stores the coordinates of the destination
		var dest_type = get_parent().get_cellv(dest_coord) # dest_type stores the tile id of the destination tile
		if direction_vec != Vector2(0,0):
			if dest_type == 1: # wall
				pass # no movement
			elif dest_type == 2: # spike
				deflate() # deflates player
			else:
				position += direction_vec * get_parent().cell_size # movement occurs!
				
func deflate(): # deflates player
	$AnimatedSprite.set_animation("deflated")
	is_healthy = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_player()
