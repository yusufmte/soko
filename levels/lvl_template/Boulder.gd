extends Node2D

export var is_topside = true # says whether bould is topside
export var bould_type = "c"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_bould_type(new_type):
	bould_type = new_type
	if bould_type == "c":
		$CBoulderSprite.show()
		$TBoulderSprite.hide()
	elif bould_type == "t":
		$TBoulderSprite.show()
		$CBoulderSprite.hide()

func switch_bould_type():
	if bould_type == "c":
		change_bould_type("t")
	elif bould_type == "t":
		change_bould_type("c")
	
func rotate_bould(dir): # rotates bould (should happen when pushed)
	if bould_type == "c":
		$CBoulderSprite.rotate(dir*PI/2)
	elif bould_type == "t":
		$TBoulderSprite.rotate(2*PI/3)
	
func knock_bould(): # knocks bould down (should happen at holes)
	if bould_type == "c":
		$FallAnimation.play("cfall")
	elif bould_type == "t":
		$FallAnimation.play("tfall")
	is_topside = false

