extends Node2D

@export var REST_LENGTH = 200.0
@export var STIFFNESS = 15.0
@export var DAMPING = 1.0
@export var MAX_DISTANCE = 300.0
var DISTANCE = 0

@onready var ray: RayCast2D = $Ray
@onready var player: CharacterBody2D = $".."
@onready var rope: Line2D = $Rope
@onready var hook: Sprite2D = $hook
@onready var debug_point_1: Sprite2D = $debug_point_1
@onready var debug_point_2: Sprite2D = $debug_point_2
@onready var debug_point_3: Sprite2D = $debug_point_3
@onready var hookanim: AnimationPlayer = $"../Hooksprite/AnimationPlayer"
@onready var detection: RayCast2D = $Detection
@onready var distance_label: Label = $"../DebugMenu/VBoxContainer/Distance"
@onready var max_distance_label: Label = $"../DebugMenu/VBoxContainer/Max_distance"
@onready var rope_left_label: Label = $"../DebugMenu/VBoxContainer/rope_left"
@onready var velocity_label: Label = $"../DebugMenu/VBoxContainer/velocitylabel"
@onready var ui_output_1_label: Label = $"../DebugMenu/VBoxContainer/ui_output_1"
@onready var ui_output_2_label: Label = $"../DebugMenu/VBoxContainer/ui_output_2"


var launched = false
var target: Vector2

func _ready() -> void:
	hook.visible = false
	debug_point_3.visible = false
	rope_left_label.text = "Leftover rope: "+str(MAX_DISTANCE)+"m"
	max_distance_label.text = "Max distance: "+str(MAX_DISTANCE)+"m"


func _process(delta):
	if !detection.is_colliding() || detection.get_collision_point() != ray.get_collision_point():
		ui_output_2_label.text = "Cant shoot"
	else:
		ui_output_2_label.text = "Can shoot"
	ray.look_at(get_global_mouse_position())
	detection.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("grapple"):
		launch()
	if Input.is_action_just_released("grapple"):
		retract()
	if launched:
		handle_grapple(delta)
	if ray.is_colliding():
		DISTANCE = to_local(ray.get_collision_point()).distance_to(player.global_position)
		distance_label.text = "Distance: "+ str(int(DISTANCE)) +"m"
		debug_point_1.global_position = ray.get_collision_point()
		debug_point_2.global_position = detection.get_collision_point()
	else:
		distance_label.text = "Distance: ∞m"


func launch():
	hookanim.play("Rotate")
	if ray.is_colliding() and DISTANCE < MAX_DISTANCE:
		if detection.get_collision_point() == ray.get_collision_point():
			debug_point_2.global_position = detection.get_collision_point()
			debug_point_3.global_position = ray.get_collision_point()
			rope_left_label.text = "Leftover rope: "+str(MAX_DISTANCE-DISTANCE)+"m"
			hook.visible = true
			launched = true
			target = ray.get_collision_point()
			rope.show()
	else:
		launched = false


func retract():
	hookanim.play("RESET")
	launched = false
	rope.hide()
	hook.visible = false
	rope_left_label.text = "Leftover rope: "+str(MAX_DISTANCE)+"m"
	debug_point_3.visible = false


func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	var displacement = target_dist - REST_LENGTH
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = STIFFNESS * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var DAMPING = -DAMPING * vel_dot * target_dir
		
		force = spring_force + DAMPING
		
	
	player.velocity += force * delta
	update_rope()


func update_rope():
	rope.set_point_position(1, to_local(target))
	hook.position = to_local(target)
