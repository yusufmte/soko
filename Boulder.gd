extends Node2D

export var is_topside = true # says whether bould is topside

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func rotate_bould(dir): # rotates bould (should happen when pushed)
	if dir == "ccw": $AnimatedSprite.rotate(-PI/2)
	if dir == "cw": $AnimatedSprite.rotate(PI/2)
	
func knock_bould(): # knocks bould down (should happen at holes)
	$AnimatedSprite.play("falling")
	is_topside = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass