extends CanvasLayer

@export var initial_lives: int = 3  # Número inicial de vidas
var lives: int

func _ready():
	lives = initial_lives
	update_life_counter()
	$PauseButton.pressed.connect(toggle_pause)

# Função para alternar o estado de pausa
func toggle_pause():
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		$PauseButton.text = "⏸ Resume"
	else:
		$PauseButton.text = "⏸ Pause"

# Atualiza o texto do contador de vidas
func update_life_counter():
	$LifeCounter/Label.text = "X " + str(lives)

# Reduz vidas e verifica fim de jogo
func lose_life():
	lives -= 1
	update_life_counter()
	if lives <= 0:
		game_over()

# Exibe "Game Over" e pausa o jogo
func game_over():
	get_tree().paused = true
	await get_tree().create_timer(2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")  # Carrega o menu principal
