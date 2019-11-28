extends Node

var current_level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# connect buttons
	$Menu.connect("quit",self,"quit_button")
	$Menu.connect("level_selected",self,"load_level")
	$HUD.connect("restart",self,"reload_level")
	$HUD.connect("menu",self,"return_to_menu")
	$HUD.connect("quit",self,"quit_button")


func load_level(lvl): # when load a new level
	$Menu.hide()
	
	current_level = lvl
	
	$LevelLoader.deload_level()
	$AudioManager.stop_all()
	
	$LevelLoader.load_level(lvl)
	
	# reset HUD
	$HUD.reset(lvl)
	$HUD.show()

func reload_level():
	load_level(current_level)

func return_to_menu():
	$LevelLoader.deload_level()
	$AudioManager.stop_all()
	$HUD.hide()
	$Menu.show()

func quit_button(): # quit button pressed
	get_tree().quit() # quit the current scene tree (should exit game)

	
func _on_player_moved(): # when the player changes position
	$HUD.increment_move_counter()
	$AudioManager/walk_sound.play()

func _on_boulder_pushed(): # when the player pushes a boulder
	$AudioManager/push_sound.play()
	
func _on_thing_knocked(): # when a beuld is knocked
	$AudioManager/knock_sound.play()
	
func _on_victory(): # when win
	$HUD.set_text("You won!")
	$AudioManager/victory_sound.play()
	
func _on_defeat(): # when lose
	$HUD.set_text("You lost...")
	$AudioManager/defeat_sound.play()

func _on_pyrrhic_victory(): # when win, then get peuped
	$HUD.set_text("You...won?")
	$AudioManager/pyrrhic_victory_sound.play()