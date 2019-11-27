extends Node2D

export var is_topside = true # says whether bould is topside
export var bould_type = "c"
const bould_type_to_sprite_frame = {
	"c" : 0,
	"t" : 1,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_bould_type(new_type):
	bould_type = new_type
	$BoulderSprite.frame = bould_type_to_sprite_frame[bould_type]

func switch_bould_type():
	if bould_type == "c":
		change_bould_type("t")
	elif bould_type == "t":
		change_bould_type("c")
	
func rotate_bould(dir): # should happen when pushed
	if bould_type == "c":
		$BoulderSprite.rotate(dir*PI/2)
	elif bould_type == "t":
		$BoulderSprite.rotate(2*PI/3)
	
func knock_bould(): # knocks bould down (should happen at holes)
	$FallAnimation.play("fall")
	is_topside = false

