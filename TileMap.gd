extends TileMap

var Boulder = preload("res://Boulder.tscn")
var obstacles = [1,2] # tileid of obstacles (that upon which a boulder cannot be pushed)

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
	
	# put boulders in all the peuptiles
	for cell in get_used_cells_by_id(3):
		var beuld = Boulder.instance()
		$Boulders.add_child(beuld)
		beuld.position = map_to_world(cell) + get_cell_size()/2
		set_cellv(cell, 0) # convert floor to regular floor once initial boulder has been placed
	
func get_boulds_here(map_pos): # returns a list containing the boulders at a position
	var beulds = []
	for beuld in $Boulders.get_children():
		if beuld.is_topside and world_to_map(beuld.position) == map_pos: beulds.append(beuld) # adds any boulders there to beulds
	return beulds # return beulds (it should be empty if no boulder, and have the one boulder if there is one)
	
func attempt_bouldrop(bould): # drops a boulder if it's on a hole
	if get_cellv(world_to_map(bould.position)) == 4: # deep hole
		bould.knock_bould()

func push_bould(bould,dir): # moves bould in a certain direction, or returns false if it can't
	if bould.is_topside:
		var dest_coord = world_to_map(bould.position) + dir_to_displacement_vec[dir]
		var dest_type = get_cellv(dest_coord)
		if (not dest_type in obstacles) and (get_boulds_here(dest_coord).size()) == 0:
			bould.position = map_to_world(dest_coord)+cell_size/2
			match dir:
				RIGHT: bould.rotate_bould("cw")
				LEFT: bould.rotate_bould("ccw")
			attempt_bouldrop(bould)
			return true
	return false
					
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
