extends CharacterBody2D

@export var SPEED = 500.0
@export var JUMP_VELOCITY = -600.0
@export var ACCELERATION = 0.1
@export var DECELERATION = 0.1

@onready var grapplecontroller := $GrappleController
@onready var hookanim: AnimationPlayer = $Hooksprite/AnimationPlayer
@onready var playeranim: AnimationPlayer = $Playersprite/AnimationPlayer
@onready var player: CharacterBody2D = $"."
@onready var camera_2d: Camera2DPlus = $Camera2D


var jumping = false
var RESETPOS = Vector2(62, -128)
var ui_output_1 = "None"
var ui_output_2 = "None"
var can_jump = true

func _physics_process(delta):
	#if player.global_position.y > 10:
		#position = RESETPOS
	if not is_on_floor():
		jumping = false
		velocity += get_gravity() * delta
	if !jumping:
		can_jump = true
	
	if Input.is_action_just_pressed("jump") && is_on_floor() && !jumping:
		can_jump = false
		velocity.y += JUMP_VELOCITY
		jumping = true
	elif Input.is_action_just_pressed("jump") && grapplecontroller.launched && !jumping:
		can_jump = false
		velocity.y += JUMP_VELOCITY
		jumping = true
	
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
		grapplecontroller.retract()
		position.x = 13081
		position.y = -95

func _on_area_2d_body_entered(_body: Node2D) -> void:
	grapplecontroller.retract()
	ui_output_1 = "in area"
	position.x = 200
	position.y = -120


func _on_portal_area_body_entered(_body: Node2D) -> void:
	camera_2d.flash(Color.from_string("portal_blue","#005B55"))
	grapplecontroller.retract()
	position.x = 13081
	position.y = -95
