extends Node

var current_level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# connect buttons
	$Menu/QuitButt.connect("pressed",self,"quit_button")
	$HUD.connect("restart",self,"reload_level")
	$HUD.connect("menu",self,"return_to_menu")
	$HUD.connect("quit",self,"quit_button")
	
	# populate level select box
	for i in range(num_levels()-1):
		$Menu/LevelSelectBox.add_item("Level "+str(i+1))
		
	$Menu/LevelSelectBox.connect("item_activated",self,"_on_level_selected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func num_levels(): # returns number of levels
	var level_count = 1
	var file = File.new()
	while file.file_exists("res://levels/level"+str(level_count)+".tscn"):
		level_count += 1
	return level_count

func _on_level_selected(lvl): # when a level is activated through the selector
	load_level(lvl+1) # need to add one because of the indices in the selector box
	
func load_level(lvl): # when load a new level

	$Menu.hide()
	
	current_level = lvl
	
	# deload current level, then load new one
	deload_level()
	var Level = load("res://levels/level"+str(lvl)+".tscn")
	var level = Level.instance()
	level.set_name("current_level")
	add_child(level) # then make a new one
	
	# reset HUD
	$HUD.reset(lvl)
	$HUD.show()
	
	# connect all the signals
	level.connect("player_moved",self,"_on_player_moved")
	level.connect("victory",self,"_on_victory")
	level.connect("defeat",self,"_on_defeat")
	level.connect("pyrrhic_victory",self,"_on_pyrrhic_victory")
	level.connect("bouldpush",self,"_on_boulder_pushed")
	level.connect("knock",self,"_on_thing_knocked")
	
func deload_level():
	for child in get_children(): # if there's a level, remove it
		if child.get_name() == "current_level":
			child.free() # this should be queue_free(), but that results in player duplication...pls remember to address this issue later
	for audio in $AudioManager.get_children():
		audio.stop() # stop any currently playing audio
	$HUD.hide()

func reload_level():
	load_level(current_level)

func return_to_menu():
	deload_level()
	$Menu.show()

func quit_button(): # quit button pressed
	get_tree().quit() # quit the current scene tree (should exit game)

	
func _on_player_moved(): # when the player changes position
	$HUD/MoveCounter.text = str(int($HUD/MoveCounter.text)+1) # increment movecounter
	$AudioManager/walk_sound.play()

func _on_boulder_pushed(): # when the player pushes a boulder
	$AudioManager/push_sound.play()
	
func _on_thing_knocked(): # when a beuld is knocked
	$AudioManager/knock_sound.play()
	
func _on_victory(): # when win
	$HUD/MsgLabel.text = "You won!"
	$AudioManager/victory_sound.play()
	
func _on_defeat(): # when lose
	$HUD/MsgLabel.text = "You lost..."
	$AudioManager/defeat_sound.play()

func _on_pyrrhic_victory(): # when win, then get peuped
	$HUD/MsgLabel.text = "You...won?"
	$AudioManager/pyrrhic_victory_sound.play()