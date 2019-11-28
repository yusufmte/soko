extends Node



func load_level(lvl):
	var Level = load("res://levels/level"+str(lvl)+".tscn")
	var level = Level.instance()
	add_child(level)
	
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