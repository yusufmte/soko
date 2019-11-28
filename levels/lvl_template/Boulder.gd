extends Node2D

export var is_topside = true # says whether bould is topside

enum BoulderType {CIRCLE, TRIANGLE}

export (BoulderType) var bould_type = BoulderType.CIRCLE

const bould_type_to_sprite_frame = {
	BoulderType.CIRCLE : 0,
	BoulderType.TRIANGLE : 1,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_bould_type(new_type):
	bould_type = new_type
	$BoulderSprite.frame = bould_type_to_sprite_frame[bould_type]

func switch_bould_type():
	if bould_type == BoulderType.CIRCLE:
		change_bould_type(BoulderType.TRIANGLE)
	elif bould_type == BoulderType.TRIANGLE:
		change_bould_type(BoulderType.CIRCLE)
	
func rotate_bould(dir): # should happen when pushed
	if bould_type == BoulderType.CIRCLE:
		$BoulderSprite.rotate(dir*PI/2)
	elif bould_type == BoulderType.TRIANGLE:
		$BoulderSprite.rotate(2*PI/3)
	
func knock_bould(): # knocks bould down (should happen at holes)
	$FallAnimation.play("fall")
	is_topside = false
	
func is_circle():
	return bould_type == BoulderType.CIRCLE

func is_triangle():
	return bould_type == BoulderType.TRIANGLE

