extends Node

func stop_all():
	for audio in get_children():
		audio.stop()