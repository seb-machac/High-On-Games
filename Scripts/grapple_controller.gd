extends Node2D
#test
@export var rest_length = 200.0
@export var stiffness = 15.0
@export var damping = 1.0
@export var max_distance = 10000.0

@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var player := get_parent()
@onready var ray := $RayCast2D
@onready var rope := $Line2D
@onready var hook := $Sprite2D

var targetpoint
var launched = false
var target: Vector2


func _process(delta):
	ray.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("grapple"):
		launch()
	if Input.is_action_just_released("grapple"):
		retract()
	if launched:
		handle_grapple(delta)

func launch():
	targetpoint = Vector2(ray.get_collision_point().x, ray.get_collision_point().y).normalized() * 3
	var distance = (targetpoint - ray.global_position).length()
	print(distance)
	if ray.is_colliding() and distance < max_distance:
		hook.visible = true
		launched = true
		target = ray.get_collision_point()
		rope.show()

func retract():
	launched = false
	rope.hide()
	hook.visible = false

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
