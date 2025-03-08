extends CanvasLayer

@export var initial_lives: int = 3  # Número inicial de vidas
var lives: int
@onready var life_icons := [$LifeCounter/Life1, $LifeCounter/Life2, $LifeCounter/Life3]  # Lista de corações

func _ready():
	lives = initial_lives
	update_life_counter()
	$PauseButton.pressed.connect(toggle_pause)
	Signals.on_score_increment.connect(self._on_score_increment)


	
	
@onready var scoreLabel := $Score
var score: int = 0

func _on_score_increment(amount: int):
	score += amount
	$Score.text = str(score)


# Função para alternar o estado de pausa
func toggle_pause():
	get_tree().paused = not get_tree().paused
	
	if get_tree().paused:
		$PauseButton.text = "⏸ Resume"
		$HomeButton.visible = true  # Mostra o botão Home quando pausado
	else:
		$PauseButton.text = "⏸ Pause"
		$HomeButton.visible = false  # Esconde o botão Home quando despausado

func _on_home_button_pressed():
	get_tree().paused = false  # Despausa antes de mudar de cena
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")  # Muda para o menu principal



# Atualiza o texto do contador de vidas
func update_life_counter():
	$LifeCounter/Label.text = "X " + str(lives)
	# Esconde os corações de acordo com a quantidade de vidas restantes
	for i in range(3):  # Loop de 0 a 2
		if i < lives:
			life_icons[i].visible = true  # Mantém visível se o jogador ainda tiver essa vida
		else:
			life_icons[i].visible = false  # Esconde se a vida foi perdida


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
