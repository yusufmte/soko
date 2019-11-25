extends TileMap

var Boulders = preload("res://Boulder.tscn")
var obstacles = [1,2] # tileid of obstacles (that upon which a boulder cannot be pushed)
enum {NONE, UP, DOWN, LEFT, RIGHT}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# put boulders in all the peuptiles
	for cell in get_used_cells_by_id(3):
		var beuld = Boulders.instance()
		$Boulders.add_child(beuld)
		beuld.position = map_to_world(cell) + get_cell_size()/2
	
func get_boulds_here(map_pos): # returns a list containing the boulders at a position
	var beulds = []
	for beuld in $Boulders.get_children():
		if beuld.is_topside and world_to_map(beuld.position) == map_pos: beulds.append(beuld) # adds any boulders there to beulds
	return beulds # return beulds (it should be empty if no boulder, and have the one boulder if there is one)
	
func attempt_bouldrop(bould): # drops a boulder if it's on a hole
	if get_cellv(world_to_map(bould.position)) == 4:
		bould.knock_bould()

func push_bould(bould,dir): # moves bould in a certain direction, or returns false if it can't
	if bould.is_topside:
		var can_move = false
		match dir:
			RIGHT:
				var dest_coord = world_to_map(bould.position) + Vector2(1,0)
				var dest_type = get_cellv(dest_coord)
				if (not dest_type in obstacles) and (get_boulds_here(dest_coord).size() == 0):
					bould.rotate_bould("cw")
					bould.position += Vector2(1,0)*cell_size
					can_move = true
			LEFT:
				var dest_coord = world_to_map(bould.position) + Vector2(-1,0)
				var dest_type = get_cellv(dest_coord)
				if (not dest_type in obstacles) and (get_boulds_here(dest_coord).size() == 0):
					bould.rotate_bould("ccw")
					bould.position += Vector2(-1,0)*cell_size
					can_move = true
			UP:
				var dest_coord = world_to_map(bould.position) + Vector2(0,-1)
				var dest_type = get_cellv(dest_coord)
				if (not dest_type in obstacles) and (get_boulds_here(dest_coord).size() == 0):
					bould.position += Vector2(0,-1)*cell_size
					can_move = true
			DOWN:
				var dest_coord = world_to_map(bould.position) + Vector2(0,1)
				var dest_type = get_cellv(dest_coord)
				if (not dest_type in obstacles) and (get_boulds_here(dest_coord).size() == 0):
					bould.position += Vector2(0,1)*cell_size
					can_move = true
		if can_move:
			attempt_bouldrop(bould)
		return can_move
	return false
					
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass