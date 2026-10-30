extends Node

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start" # The title (~ start) inside your .dialogue file

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _show_dialogue(event):
	if event.is_action_pressed("interact"):
		DialogueManager.show_dialogue_balloon(dialogue_resource, "start") 
