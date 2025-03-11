extends Node2D

@export var enemy_scene: PackedScene  # Cena do inimigo
@export var enemy_shooter_scene: PackedScene # Cena do novo inimigo
@export var powerup_scene: PackedScene 
@export var spawn_interval: float = 2.0  # Tempo entre spawns
@export var total_waves := 10  # Número total de waves
@export var spawn_delay: float = 1.5 

var current_wave := 1  # Começa na wave 1
var enemies_remaining := 0  # Contador de inimigos restantes
var enemies_destroyed: int = 0
var min_x: float = 20
var max_x: float = 700

@onready var hud := $HUD
@onready var wave_label := $HUD/WaveLabel  # Certifique-se de ter um Label na HUD
@onready var player := $Player 

var words := [
	"space", "galaxy", "planet", "asteroid", "blackhole",
	"nebula", "starship", "orbit", "cosmos", "supernova",
	"engine", "shader", "prototype", "gameloop", "debug",
	"sprite", "pixelart", "viewport", "collision", "particles",
	"feup", "there", "happy", "tese", "put"]

func _ready():
	start_wave()  # Começa a primeira wave quando o jogo iniciar
	player.enemy_collided.connect(_on_enemy_destroyed)

func spawn_enemy():
	if enemy_scene:
		var enemy = enemy_shooter_scene.instantiate()
		enemy.position = Vector2(randf_range(min_x, max_x), 0)  # Spawn aleatório no topo
		enemy.target_word = words.pick_random()  # Escolher uma palavra aleatória
		enemy.add_to_group("enemies")
		enemy.destroyed.connect(_on_enemy_destroyed)
		add_child(enemy)

func _on_enemy_destroyed():
	enemies_remaining -= 1  # Reduz o número de inimigos restantes
	enemies_destroyed += 1 # Aumenta o número de inimigos mortos
	if enemies_destroyed % 10 == 0:
		spawn_powerup()
	# 🚨 Garante que a wave só termina quando todos os inimigos forem eliminados
	if enemies_remaining <= 0:
		check_wave_complete()

func spawn_powerup():
	if powerup_scene:
		var powerup = powerup_scene.instantiate()
		powerup.position = Vector2(randf() * get_viewport_rect().size.x, 0)
		# Sorteia aleatoriamente entre os tipos de power-ups
		var powerup_type = randi() % 2  # 0 ou 1

		if powerup_type == 0:
			powerup.type = "destroy"  # Power-up que destrói todos os inimigos
		else:
			powerup.type = "invincibility"  # Power-up de invencibilidade
		
		add_child(powerup)
		print("🎁 Power-up liberado: " + ( "Destruir todos" if powerup.type == "destroy" else "Invencibilidade"))

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var key = event.unicode if event.unicode > 0 else event.keycode
		
		# Verifica se a tecla pressionada é válida
		if key > 0:
			var character = char(key)  # Converte o código em caractere
			for enemy in get_tree().get_nodes_in_group("enemies"):
				if enemy.has_method("add_letter"):  # Garante que o inimigo tem a função
					enemy.add_letter(character)

func _on_home_button_pressed():
	get_tree().paused = false  # Despausa antes de mudar de cena
	var result = get_tree().change_scene_to_file("res://Scenes/Menu.tscn")  # Tenta mudar de cena

func start_wave():
	wave_label.text = "WAVE " + str(current_wave).pad_zeros(3) + " START"
	wave_label.show()
	await get_tree().create_timer(2).timeout  # Exibe por 2 segundos
	wave_label.hide()

	# 🚨 Corrigindo a contagem de inimigos antes de iniciar a wave
	var enemies_to_spawn = current_wave * 3 
	enemies_remaining = enemies_to_spawn

	# ⏳ Spawnando os inimigos com delay entre cada um
	for i in range(enemies_to_spawn):
		while get_tree().paused:  # ⚠️ Aguarda enquanto o jogo estiver pausado
			await get_tree().process_frame  # Espera um frame antes de checar novamente
		
		await get_tree().create_timer(1).timeout  # Pequeno delay para evitar spawn instantâneo
		spawn_enemy()

func check_wave_complete():
	if enemies_remaining <= 0:
		if current_wave < total_waves:
			await get_tree().create_timer(1).timeout  # Pequena pausa antes da nova wave
			current_wave += 1
			show_wave_complete()
		else:
			game_won()  # Se for a última wave, o jogo termina

func show_wave_complete():
	hud.hide()  # Esconde a HUD temporariamente
	wave_label.text = "WAVE " + str(current_wave).pad_zeros(3) + " CLEAR"
	wave_label.show()

	await get_tree().create_timer(3).timeout  # Exibe por 3 segundos
	wave_label.hide()
	hud.show()  # Mostra a HUD novamente

	start_wave()  # Inicia a próxima wave

func game_won():
	hud.hide()
	wave_label.text = "🎉 GAME COMPLETE 🎉\nSCORE: " + str(hud.score)
	wave_label.show()
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")  # Volta para o menu
