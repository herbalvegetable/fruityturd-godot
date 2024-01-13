extends Control

func _ready():
	visible = false

func show_panel():
	var window_size = get_viewport_rect().size
	position = Vector2(window_size[0]/2, window_size[1]/2)
	
	$ScoreText.text = 'Score: %s' % $'..'.score
	visible = true

func _on_retry_button_pressed():
	$'..'.reset()
