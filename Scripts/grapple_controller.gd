extends Node2D

@export var rest_length = 200.0
@export var stiffness = 15.0
@export var damping = 1.0
@export var max_distance = 800.0

@onready var player := get_parent()
@onready var ray := $Ray
@onready var rope := $Rope
@onready var hook := $Sprite2D
@onready var debug_line: Line2D = $debug_line
@onready var debug_point_1: Sprite2D = $debug_point_1
@onready var debug_point_2: Sprite2D = $debug_point_2
@onready var debug_point_3: Sprite2D = $debug_point_3
@onready var playernode: CharacterBody2D = $".."
@onready var detection: RayCast2D = $Detection
@onready var detection_line: Line2D = $Detection/detection_line
@onready var hookanim: AnimationPlayer = $"../Hooksprite/AnimationPlayer"

var targetpoint
var launched = false
var target: Vector2
var distance = 0
var distancestr = "0"
var leftover_rope = "Leftover rope: ∞m"
var ui_output_1 = "None"
var ui_output_2 = "None"


func _process(delta):
	targetpoint = Vector2(ray.get_collision_point().x, ray.get_collision_point().y).normalized()
	if !detection.is_colliding() || detection.get_collision_point() != ray.get_collision_point():
		ui_output_2 = "Cant shoot"
	else:
		ui_output_2 = "Can shoot"
	if debug_line.points[0].distance_to(debug_line.points[1]) > max_distance:
		debug_line.hide()
	else:
		debug_line.show()
	ray.look_at(get_global_mouse_position())
	detection.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("grapple"):
		launch()
	if Input.is_action_just_released("grapple"):
		retract()
	if launched:
		handle_grapple(delta)
	if ray.is_colliding():
		distance = to_local(ray.get_collision_point()).distance_to(player.global_position)
		distancestr = "Distance: "+ str(int(distance)) +"m"
		debug_point_1.global_position = ray.get_collision_point()
		debug_point_2.global_position = detection.get_collision_point()
	else:
		distancestr = "Distance: ∞m"


func launch():
	hookanim.play("Rotate")
	if ray.is_colliding() and distance < max_distance:
		if detection.get_collision_point() == ray.get_collision_point():
			debug_point_2.global_position = detection.get_collision_point()
			debug_point_3.global_position = ray.get_collision_point()
			leftover_rope = "Leftover rope: "+str(max_distance-distance)+"m"
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
	leftover_rope = "Leftover rope: ∞m"


func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damping * vel_dot * target_dir
		
		force = spring_force + damping
		
	
	player.velocity += force * delta
	update_rope()


func update_rope():
	rope.set_point_position(1, to_local(target))
	hook.position = to_local(target)
