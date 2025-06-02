extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const ACCELERATION = 0.1
const DECELERATION = 0.1

@onready var gc := $GrappleController

var jumping = false

func _physics_process(delta):
	if not is_on_floor():
		jumping = false
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") && is_on_floor() && !jumping:
		velocity.y += JUMP_VELOCITY
		jumping = true
		#gc.retract()
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = lerp(velocity.x, SPEED * direction, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION)
	
	move_and_slide()
	
	
func _input(event):
	if event.is_action_pressed("Escape"):
		get_tree().quit()
	if event.is_action_pressed("Reset"):
		gc.retract()
		position.x = 550
		position.y = 0
