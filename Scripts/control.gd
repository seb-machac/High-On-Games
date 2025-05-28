extends Control


@onready var grapple_controller: Node2D = $"../Player/GrappleController"
@onready var distance: Label = $VBoxContainer/Distance
@onready var max_distance: Label = $VBoxContainer/Max_distance
@onready var rope_left: Label = $VBoxContainer/rope_left
@onready var velocitylabel: Label = $VBoxContainer/velocitylabel
@onready var player: CharacterBody2D = $"../Player"
@onready var console: Label = $VBoxContainer/Console
@onready var control: Control = $"."

var debug_hidden = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug"):
		debug_hidden = not debug_hidden
		if debug_hidden == true:
			control.visible = false
		else:
			control.visible = true
			
	distance.text = str(grapple_controller.distancestr)
	max_distance.text = "Max Distance: "+str(grapple_controller.max_distance)+"m"
	rope_left.text = grapple_controller.leftover_rope
	velocitylabel.text = "Velocity: " +str(int(player.velocity.length()))
	console.text = grapple_controller.ui_output
	
