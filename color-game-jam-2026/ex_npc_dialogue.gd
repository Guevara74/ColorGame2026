extends RigidBody3D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact():
	if dialogue_resource:
		$"../CanvasLayer/BoxContainer/InteractText".hide()
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	else:
		print("No dialogue resource assigned to this NPC!")
		
		
		
		
