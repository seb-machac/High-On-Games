extends Control


@onready var grapple_controller: Node2D = $"../Player/GrappleController"
@onready var distance: Label = $VBoxContainer/Distance
@onready var max_distance: Label = $VBoxContainer/Max_distance
@onready var rope_left: Label = $VBoxContainer/rope_left
@onready var velocitylabel: Label = $VBoxContainer/velocitylabel
@onready var player: CharacterBody2D = $"../Player"
@onready var ui_output_1: Label = $VBoxContainer/ui_output_1
@onready var ui_output_2: Label = $VBoxContainer/ui_output_2
@onready var control: Control = $"."
@onready var debug_point_1: Sprite2D = $"../Player/GrappleController/debug_point_1"
@onready var debug_point_2: Sprite2D = $"../Player/GrappleController/debug_point_2"
@onready var debug_point_3: Sprite2D = $"../Player/GrappleController/debug_point_3"

var debug_mode = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug"):
		debug_mode = not debug_mode
		if debug_mode:
			control.visible = true
			debug_point_1.visible = true
			debug_point_2.visible = true
			debug_point_3.visible = true
		else:
			control.visible = false
			debug_point_1.visible = false
			debug_point_2.visible = false
			debug_point_3.visible = false
			
	distance.text = str(grapple_controller.distancestr)
	max_distance.text = "Max Distance: "+str(grapple_controller.max_distance)+"m"
	rope_left.text = grapple_controller.leftover_rope
	velocitylabel.text = "Velocity: " +str(int(player.velocity.length()))
	ui_output_1.text = grapple_controller.ui_output_1
	ui_output_2.text = grapple_controller.ui_output_2
	
