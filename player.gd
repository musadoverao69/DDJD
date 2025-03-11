extends Area2D  # Alterado para Area2D

@onready var sprite := $Sprite2D
@onready var powerup_light := $PointLight2D
@onready var invicibilityTimer := $InvicibilityTimer

@export var speed := 300
@export var invincTime := 6  # Tempo de invencibilidade (meio segundo)

var base_speed := 300
var powerup_active := false
var is_invincible := false  # Jogador começa sem invencibilidade
var min_x: float = 20
var max_x: float = 700

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
	
	if powerup_active and Input.is_action_just_pressed("ui_accept"):
		destroy_all_enemies()
		powerup_active = false
		print("💥 Todas as naves inimigas foram destruídas!")
	
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

# Power-up de destruição total
func apply_powerup(powerup_type):
	if powerup_type == "destroy":
		powerup_active = true
		powerup_light.visible = true
	elif powerup_type == "invincibility":
		activate_invincibility()  # Chama a função correta de invencibilidade

func destroy_all_enemies():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.destroy_enemy()
	powerup_active = false
	powerup_light.visible = false
