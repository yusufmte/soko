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
	$PlayerSprite.frame=0
	is_healthy = true

func play_movement_animation(direction): # plays movement animation in certain direction
	match direction:
		RIGHT:
			$PlayerAnimations.play("horizontal")
		LEFT:
			$PlayerAnimations.play_backwards("horizontal")
		UP:
			$PlayerAnimations.play("vertical")
		DOWN:
			$PlayerAnimations.play_backwards("vertical")

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
	position = get_parent().map_to_world( get_parent().world_to_map(position) + direction_vec ) + get_parent().cell_size/2
	get_parent().emit_signal("player_moved")

func attempt_move(direction):
	var direction_vec = dir_to_displacement_vec[direction]
	var dest_coord = get_parent().world_to_map(position) + direction_vec # dest_coord stores the MAP coordinates of the destination
	var dest_type = get_parent().get_cellv(dest_coord) # dest_type stores the tile id of the destination tile
	var no_tile_obstacle = false
	match dest_type:
		1: # wall
			pass
		2: # spike
			deflate() # deflates player
		4: # hole
			complete_move(direction_vec)
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
			
func peuped(): # player's health has been compromised
	is_healthy = false
	if get_parent().check_victory():
		get_parent().emit_signal("pyrrhic_victory") # if peuped after won
	else:
		get_parent().emit_signal("defeat") # emits defeat signal from TileMap
	

func deflate(): # deflates player
	$PlayerAnimations.stop()
	$PlayerSprite.rotation_degrees=0
	$PlayerSprite.frame = 1
	peuped()
	
func fall(): # fells player
	$PlayerAnimations.play("fall")
	peuped()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_healthy : 
		var direction = check_for_move_action()
		if direction != NONE :
			play_movement_animation(direction)
			attempt_move(direction)
