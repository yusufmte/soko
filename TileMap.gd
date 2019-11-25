extends TileMap

var Boulder = preload("res://Boulder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for cell in get_used_cells_by_id(3):
		var beuld = Boulder.instance()
		$Boulders.add_child(beuld)
		beuld.position = map_to_world(cell) + get_cell_size()/2
	
func boulder_here(map_pos):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass