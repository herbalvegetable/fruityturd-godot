extends Node2D

var pipe_scn = preload("res://scenes/pipes.tscn")

@export var pipe_num: int = 4
var pipe_spawn_x: float = 1500
var middle_y: float = 300
var pipe_margin: float = 350
var pipe_inst_arr = []

var score = 0
var score_str = '[left] Score: [color="lime"]%s'
var highscore = score
var highscore_str = '[left] Highscore: [color="cyan"]%s'
var is_game_over = false
var is_game_started = false

func _ready():
	print('Level is ready!')
	init_pipe_inst()
	set_score_text(score)
	set_highscore_text(highscore)
	
func init_pipe_inst():
	for inst in pipe_inst_arr:
		inst.queue_free()
	
	pipe_inst_arr = []
	
	for i in range(pipe_num):
		var pipe_inst = create_pipe_inst(700 + pipe_margin*i)
		pipe_inst_arr.append(pipe_inst)

func _process(delta):
	if is_game_over:
		return
		
	if not is_game_started and Input.is_action_just_pressed("jump"):
		start_game()
	
	# Loop through pipe insts
	for i in pipe_inst_arr.size():
		var inst = pipe_inst_arr[i]
		
		# Update score when bird passes pipe
		if inst.position.x < $Bird.position.x and not inst.passed:
			update_score()
			inst.passed = true
		
		# Reset pipe inst when it goes off-screen (left side)
		if inst.position.x < -50:
			# spawn pipe 1xmargin behind right-most pipe
			var prev_i: int = i - 1
			if prev_i < 0:
				prev_i = pipe_inst_arr.size() - 1
			
			var next_inst = pipe_inst_arr[prev_i]
			inst.position = Vector2(next_inst.position.x + pipe_margin, $Pipes.get_rand_y())
			inst.passed = false

func start_game():
	$StartMenu.visible = false
	is_game_started = true
	$Highscore.visible = false

func create_pipe_inst(x):
	var pipe_inst = pipe_scn.instantiate()
	pipe_inst.position = Vector2(x, $Pipes.get_rand_y())
	$PipeInstances.add_child(pipe_inst)
	return pipe_inst

func set_score_text(num):
	$Score.text = score_str % num
func update_score():
	score += 1
	print('Score: ', score)
	set_score_text(score)
	
func set_highscore_text(num):
	$Highscore.text = highscore_str % num
	
func reset():
	print('Reset game')
	init_pipe_inst() # init pipe instances
	$Bird.init() # init BIRD
	$GameOver.visible = false # hide GameOver screen
	$StartMenu.visible = true # show Start menu
	score = 0 # reset score
	set_score_text(score)
	is_game_over = false # reset game_over var
	is_game_started = false # reset game_started var
	

