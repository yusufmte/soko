extends Panel

signal restart
signal menu
signal quit

func _on_RestartButt_pressed():
	emit_signal("restart")

func _on_MenuButt_pressed():
	emit_signal("menu")


func _on_QuitButt_pressed():
	emit_signal("quit")

func reset(lvl):
	$MsgLabel.text = ""
	$MoveCounter.text = "0"
	$LvlLabel.text = "Level "+str(lvl)