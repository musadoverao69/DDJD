extends Area2D

@onready var sprite := $Sprite2D
@onready var powerup_light := $PointLight2D
@onready var invicibilityTimer := $InvicibilityTimer

@export var speed := 300
@export var invincTime := 4  # Tempo de invencibilidade 

var base_speed := 300
var powerup_active := false
var is_invincible := false  # Jogador começa sem invencibilidade
var min_x: float = 20
var max_x: float = 700

var stored_powerup: String = ""  # Armazena o power-up coletado

signal enemy_collided

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))  # Conecta o sinal
	powerup_light.visible = false
	invicibilityTimer.wait_time = invincTime  # Define o tempo do timer
	invicibilityTimer.connect("timeout", Callable(self, "_on_invincibility_timer_timeout"))  # Conecta o timer

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	position += input_vector.normalized() * speed * delta
	
	position.x = clamp(position.x, min_x, max_x)
	
	if Input.is_action_just_pressed("ui_accept"):
		if powerup_active:  # Se o power-up de explosão estiver ativo
			destroy_random_enemies(4)  # Ativa a explosão
			powerup_active = false
			powerup_light.visible = false
			print("💥 Inimigos mais próximos destruídos!")
		elif stored_powerup == "invincibility":  # Se o power-up de escudo estiver armazenado
			activate_invincibility()  # Ativa o escudo
			stored_powerup = ""  # Limpa o power-up armazenado
			print("🛡️ Escudo ativado!")
	
	if input_vector.x < 0:
		sprite.frame = 0
	elif input_vector.x > 0:
		sprite.frame = 2
	else: 
		sprite.frame = 1

# Função chamada ao colidir com um inimigo
func _on_area_entered(area):
	if area.is_in_group("enemies"):  # Verifica se o objeto é um inimigo
		if is_invincible:  # Se o jogador está invencível
			area.queue_free()  # Destroi o inimigo ao colidir
			emit_signal("enemy_collided")
		else:
			# Toca o som de hit imediatamente
			$hit_sound.play()  # Aqui o nó "hit_sound" é um AudioStreamPlayer2D no jogador
			area.queue_free()  # Destroi o inimigo normalmente
			$"/root/Main/HUD".lose_life()  # Reduz uma vida usando o HUD
			emit_signal("enemy_collided") # 🚨 Emite o sinal para o Main reduzir o número de inimigos restantes
	
	# Verifica se a área é um projétil do boss
	elif area.is_in_group("boss_projectiles"):
		if not is_invincible:  # Só perde vida se não estiver invencível
			$hit_sound.play()  # Toca o som de hit
			$"/root/Main/HUD".lose_life()  # Reduz uma vida usando o HUD
			area.queue_free()  # Remove o projétil da cena

# Power-up de invencibilidade
func activate_invincibility():
	is_invincible = true  # O jogador fica invencível
	sprite.self_modulate = Color(1, 1, 1, 0.5)  # Deixa meio transparente
	invicibilityTimer.start()  # Inicia o timer
	print("🛡️ Invencibilidade ativada!")

func _on_invincibility_timer_timeout():
	is_invincible = false  # Remove a invencibilidade
	sprite.self_modulate = Color(1, 1, 1, 1)  # Volta ao normal
	print("❌ Invencibilidade acabou!")

# Função para aplicar power-ups
func apply_powerup(powerup_type):
	if powerup_type == "destroy":
		powerup_active = true
		powerup_light.visible = true
	elif powerup_type == "invincibility":
		stored_powerup = "invincibility"  # Armazena o power-up de escudo
		print("Escudo coletado! Pressione Enter para ativá-lo.")

# Função de destruição dos inimigos 
func destroy_random_enemies(count: int = 4):
	# Pega todos os inimigos da cena
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	# Embaralha a lista de inimigos
	enemies.shuffle()

	# Destroi os 'count' primeiros inimigos da lista embaralhada
	for i in range(min(count, enemies.size())):
		var enemy = enemies[i]
		enemy.destroy_enemy()
	print("💥 Inimigos aleatórios destruídos!")

func store_powerup(powerup_type):
	if powerup_type == "invincibility":
		stored_powerup = "invincibility"  # Armazena o power-up de escudo
		print("Escudo coletado! Pressione Enter para ativá-lo.")
