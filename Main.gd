extends Node
var Level = preload("res://TileMap.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_HUD_restart()
	$HUD/Panel/RestartButt.connect("pressed",self,"_on_HUD_restart")
	$HUD/Panel/QuitButt.connect("pressed",self,"_on_HUD_quit")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HUD_restart(): # when restart button is clicked
	for child in get_children(): # if there's a level, remove it
		if child.get_name() == "level":
			child.free() # this should be queue_free(), but that results in player duplication...pls remember to address this issue later
	var level = Level.instance()
	level.set_name("level")
	add_child(level) # then make a new one
	
	# connect all the signals
	level.connect("player_moved",self,"_on_player_moved")
	level.connect("victory",self,"_on_victory")
	level.connect("defeat",self,"_on_defeat")
	level.connect("pyrrhic_victory",self,"_on_pyrrhic_victory")
	
	# reset label text
	$HUD/Panel/MsgLabel.text = ""
	$HUD/Panel/MoveLabel/MoveCounter.text = "0"
	
func _on_HUD_quit(): # quit button pressed
	get_tree().quit() # quit the current scene tree (should exit game)
	
func _on_player_moved(): # when the player changes position
	$HUD/Panel/MoveLabel/MoveCounter.text = str(int($HUD/Panel/MoveLabel/MoveCounter.text)+1) # increment movecounter
	
func _on_victory(): # when win
	$HUD/Panel/MsgLabel.text = "You won!"
	$AudioManager/victory_sound.play()
	
func _on_defeat(): # when lose
	$HUD/Panel/MsgLabel.text = "You lost..."
	$AudioManager/defeat_sound.play()

func _on_pyrrhic_victory(): # when win, then get peuped
	$HUD/Panel/MsgLabel.text = "You...won?"
	$AudioManager/pyrrhic_victory_sound.play()