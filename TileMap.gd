extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass# Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_player_moved():
	if get_cellv(world_to_map($Player.position)) == 2:
		$Player/AnimatedSprite.set_animation("deflated")
