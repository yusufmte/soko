extends Node

# size of loaded level in pixels
var level_size : Vector2


func load_level(lvl):
	var Level = load("res://levels/level"+str(lvl)+".tscn")
	var level = Level.instance()
	add_child(level)
	
	var used_cells : Array = level.get_used_cells()
	var xs := Array()
	var ys := Array()
	for cell in used_cells:
		xs.append(cell.x)
		ys.append(cell.y)
	level_size = level.get_cell_size() * Vector2(xs.max(),ys.max())


	# connect all the signals
	var main_node = get_parent()
	level.connect("player_moved",main_node,"_on_player_moved")
	level.connect("victory",main_node,"_on_victory")
	level.connect("defeat",main_node,"_on_defeat")
	level.connect("pyrrhic_victory",main_node,"_on_pyrrhic_victory")
	level.connect("bouldpush",main_node,"_on_boulder_pushed")
	level.connect("knock",main_node,"_on_thing_knocked")
	

func deload_level():
	for child in get_children(): # if there's a level, remove it
		child.queue_free()