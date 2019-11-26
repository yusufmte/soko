extends Node2D

export var is_topside = true # says whether bould is topside

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func rotate_bould(dir): # rotates bould (should happen when pushed)
	if dir == "ccw": $BoulderSprite.rotate(-PI/2)
	if dir == "cw": $BoulderSprite.rotate(PI/2)
	
func knock_bould(): # knocks bould down (should happen at holes)
	$FallAnimation.play("fall")
	is_topside = false

