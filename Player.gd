extends Node2D

export var is_healthy = true

enum {NONE, UP, DOWN, LEFT, RIGHT}
const dir_to_displacement_vec = {
	NONE  : Vector2(),
	UP    : Vector2(0,-1),
	DOWN  : Vector2(0,1),
	LEFT  : Vector2(-1,0),
	RIGHT : Vector2(1,0),
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_animation("horizontal")
	is_healthy = true

func play_movement_animation(direction): # plays movement animation in certain direction
	match direction:
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

# Returns a direction if there was movement or NONE if not
func check_for_move_action(): # connects key to movement direction
	var direction = NONE # move direction
	if Input.is_action_just_pressed("ui_right"):
		direction = RIGHT
	elif Input.is_action_just_pressed("ui_left"):
		direction = LEFT
	elif Input.is_action_just_pressed("ui_up"):
		direction = UP
	elif Input.is_action_just_pressed("ui_down"):
		direction = DOWN
	return direction

func complete_move(direction_vec):
	position += direction_vec * get_parent().cell_size

func attempt_move(direction):
	var direction_vec = dir_to_displacement_vec[direction]
	var dest_coord = get_parent().world_to_map(position) + direction_vec # dest_coord stores the MAP coordinates of the destination
	var dest_type = get_parent().get_cellv(dest_coord) # dest_type stores the tile id of the destination tile
	var no_tile_obstacle = false
	match dest_type:
		1: # wall
			pass # no movement
		2: # spike
			deflate() # deflates player
		4: # hole
			position += direction_vec * get_parent().cell_size # movement occurs...
			fall() # ...much to the player's peup :D
		_:
			no_tile_obstacle = true
	if(no_tile_obstacle):
		var beuld = get_parent().get_boulds_here(dest_coord) # the list of boulders in the destination
		if beuld.size() > 0: # if there is a boulder there...
			if get_parent().push_bould(beuld[0],direction): # ...and, if the boulder is pushed...
				complete_move(direction_vec) # ...then movement occurs!
		else: # on the other hand, if no boulder...
			complete_move(direction_vec) # ...movement occurs!

func deflate(): # deflates player
	$AnimatedSprite.set_animation("deflated")
	is_healthy = false
	
func fall(): # fells player
	$AnimatedSprite.play("falling")
	is_healthy = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_healthy : 
		var direction = check_for_move_action()
		if direction != NONE :
			play_movement_animation(direction)
			attempt_move(direction)
