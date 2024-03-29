extends TileMap

var Boulder = preload("res://levels/lvl_template/Boulder.tscn")
var obstacles = [1,2] # tileid of obstacles (that upon which a boulder cannot be pushed)

signal victory
signal defeat
signal pyrrhic_victory
signal player_moved
signal bouldpush
signal knock

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
	for cell in (get_used_cells_by_id(3)+get_used_cells_by_id(7)): # peuptile
		var beuld = Boulder.instance()
		if cell in get_used_cells_by_id(3):
			beuld.change_bould_type(beuld.BoulderType.CIRCLE)
		elif cell in get_used_cells_by_id(7):
			beuld.change_bould_type(beuld.BoulderType.TRIANGLE)
		$Boulders.add_child(beuld)
		beuld.position = map_to_world(cell) + get_cell_size()/2
		set_cellv(cell, 0) # convert floor to regular floor once initial boulder has been placed
		
	# put player in start position
	for cell in get_used_cells_by_id(6): # player start tile
		$Player.position = map_to_world(cell) + get_cell_size()/2
		set_cellv(cell, 0)
	
func get_boulds_here(map_pos): # returns a list containing the boulders at a position
	var beulds = []
	for beuld in $Boulders.get_children():
		if beuld.is_topside and world_to_map(beuld.position) == map_pos: beulds.append(beuld) # adds any boulders there to beulds
	return beulds # return beulds (it should be empty if no boulder, and have the one boulder if there is one)

func check_victory(): # checks for victory, and sends victory signal if so
	for beuld in $Boulders.get_children():
		if beuld.is_topside == true: return false
	if $Player.is_healthy: emit_signal("victory")
	return true
	
func check_boulded_tile(bould): # drops a boulder if it's on a hole
	var tile_type = get_cellv(world_to_map(bould.position))
	if (bould.is_circle() and tile_type == 4) or (bould.is_triangle() and tile_type == 8): # correctly shapred hole
		bould.knock_bould()
		emit_signal("knock")
		check_victory() # check for victory every time a bould is knocked
	if tile_type == 9: # switcher tile
		bould.switch_bould_type()

func push_bould(bould,dir): # moves bould in a certain direction, or returns false if it can't
	if bould.is_topside:
		var dest_coord = world_to_map(bould.position) + dir_to_displacement_vec[dir]
		var dest_type = get_cellv(dest_coord)
		if (not dest_type in obstacles) and (get_boulds_here(dest_coord).size()) == 0:
			match dir:
				RIGHT: bould.rotate_bould(1)
				LEFT: bould.rotate_bould(-1)
			emit_signal("bouldpush")
			bould.position = map_to_world(dest_coord)+cell_size/2
			check_boulded_tile(bould)
			return true
	return false

