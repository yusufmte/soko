extends Panel

signal quit

func _on_QuitButt_pressed():
	emit_signal("quit")
