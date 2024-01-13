extends Node2D

# @export makes var editable in inspector -->
@export var speed: float = 300
@export var gravity: float = 900
@export var jumpPower: float = 350

var yv : float = 0
var rotSpeed: float = 75
var minRot: float = -45
var maxRot: float = 90

func _ready():
	print('Bird Sprite is ready!')
	init()
	$BirdSprite.scale = Vector2(0.2, 0.2)
	
	#set size of area/collision - JANKY
	# dont set collision size relative to sprite size LOL
	$Area2D/CollisionShape2D.shape.extents = Vector2(25, 25)
	
func init():
	position = Vector2(250, get_viewport_rect().size[1]/2)
	yv = -jumpPower
	$BirdSprite.rotation_degrees = -15

func _process(delta):
	if $'..'.is_game_started:
		movement(delta)
	if not $'..'.is_game_over:
		controls(delta)

func movement(delta):
	# velocity
	if position.y < 1000:
		position.y += yv * delta
	# gravity
	yv += gravity * delta
	# clockwise rot
	$BirdSprite.rotation_degrees += rotSpeed * delta
	if $BirdSprite.rotation_degrees > maxRot:
		$BirdSprite.rotation_degrees = maxRot
	
	#game over guard
	if $'..'.is_game_over:
		return
	
	# check if bird out of screen/level
	if position.y > 700:
		game_over()
	
func controls(delta):
	if Input.is_action_just_pressed('jump'):
		yv = -jumpPower
		$BirdSprite.rotation_degrees = minRot

# on collision with pipes
func _on_area_2d_area_entered(area):
	print('collision: ', area.name)
	if $'..'.is_game_over:
		return
	
	if area.name in ['TopPipe', 'BottomPipe']:
		game_over()
		
# game over
func game_over():
	print('bird die')
	$'..'.is_game_over = true
	yv = -500
	$BirdSprite.rotation_degrees = minRot
	
	$'..'.highscore = max($'..'.score, $'..'.highscore)
	print('High Score: ', $'..'.highscore)
	$'..'.set_highscore_text($'..'.highscore)
	$'..'/Highscore.visible = true
	
	$'../GameOver'.show_panel()
	
	
