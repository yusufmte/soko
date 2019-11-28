extends Panel

signal quit
signal level_selected

func _ready():
	# populate level select box
	for i in range(num_levels()-1):
		$LevelSelectBox.add_item("Level "+str(i+1))

func num_levels(): # returns number of levels
	var level_count = 1
	var file = File.new()
	while file.file_exists("res://levels/level"+str(level_count)+".tscn"):
		level_count += 1
	return level_count

func _on_QuitButt_pressed():
	emit_signal("quit")

func _on_LevelSelectBox_item_activated(index):
	emit_signal("level_selected",index + 1) # need to add one because of the indices in the selector box
