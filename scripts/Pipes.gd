extends Node2D

var pipe_scn = preload("res://scenes/pipes.tscn")

var rng = RandomNumberGenerator.new()

@export var xspeed = 200
@export var gap_height = 150
@export var pipe_width = 20

var passed = false

func _ready():
	# Set pipe positions
	# !!! toppipe / bottompipe position is RELATIVE to "Pipes" parent node
	$TopPipe.position.y = -gap_height/2
	$BottomPipe.position.y = gap_height/2
	
	# set collision shape size
	$TopPipe/CollisionShape2D.shape.extents.x = pipe_width
	$BottomPipe/CollisionShape2D.shape.extents.x = pipe_width

func _process(delta):
	var level_node = get_tree().root.get_child(0)
	if level_node.is_game_started and not level_node.is_game_over:
		movement(delta)
	
func movement(delta):
	position.x -= xspeed * delta

func get_rand_y():
	var range: float = 125.0
	#var middle_y: float = get_viewport_rect().size[1]/2
	var middle_y: float = 328
	var rand_y = middle_y + rng.randf_range(-range, range)
	return rand_y
