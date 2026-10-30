extends CharacterBody3D

var speed
const WALK_SPEED = 10.0
const SPRINT_SPEED = 18.0
const JUMP_VELOCITY = 10.0
const SENSITIVITY = 0.003

#bob variable
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

#dialogue variable
var can_move = false
var dialogue_active = false

var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
	
func _physics_process(delta: float) -> void:
	
	if dialogue_active:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	#Handle ineraction
	$"../CanvasLayer/BoxContainer/InteractText".hide()
	if %SeeCast.is_colliding():
		var target = %SeeCast.get_collider()
		if target != null and target.has_method("interact"):
			$"../CanvasLayer/BoxContainer/InteractText".show()
			if Input.is_action_just_pressed("interact"):
				dialogue_active = true
				target.interact()
				
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#Handle sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("back", "front", "left", "right")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 1.1)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 1.1)
		
	#head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	move_and_slide()


#head bob
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
	
#dialogue control
func _on_dialogue_started() -> void:
	dialogue_active = true
	can_move = false
	
	
func _on_dialogue_ended() -> void:
	dialogue_active = false
	can_move = true
	
