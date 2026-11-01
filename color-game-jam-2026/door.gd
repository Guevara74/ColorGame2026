extends StaticBody3D

@onready var door = $MeshInstance3D
@onready var outline_mesh = $MeshInstance3D/MeshInstance3D

var selected = false
var outlined_width = 0.05

func _ready():
	get_tree().get_first_node_in_group("player").interact_object.connect(_set_selected)
	outline_mesh.visible = false
	
func _process(_delta):
	outline_mesh.visible = selected
	
	if selected:
		door.position.y = outlined_width
	else:
		door.position.y = 0
	
func _set_selected(new_self):
	selected = new_self 
