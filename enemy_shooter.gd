extends Node2D

@export var speed: float = 77.0  # Velocidade do inimigo
@export var letter_scene: PackedScene  # Cena do projétil (letra)

var target_word: String = ""  # Palavra do inimigo
var typed_word: String = ""  # O que o jogador digitou
var player: Area2D
@onready var explosion_sound := $DeathSound  # Referência para o som de explosão

var plEnemyExplosion := preload("res://Scenes/EnemyExplosion.tscn")  # Efeito de explosão

signal destroyed

func _ready():
	$WordLabel.bbcode_enabled = true
	$WordLabel.text = target_word  # Exibir a palavra
	$ShootTimer.wait_time = 8.0
	$ShootTimer.start()  # Inicia o timer de disparo
	$ShootTimer.timeout.connect(_on_ShootTimer_timeout)
	_on_ShootTimer_timeout()  # Força o disparo
	player = get_tree().get_first_node_in_group("player") 
	if not player:
		print("⚠️ ERRO: Player não encontrado!")

func _process(delta):
	if player:
		var direction = (player.position - position).normalized()
		position += direction * speed * delta  # Move na direção do player

	# Remove o inimigo caso saia da tela
	if position.y > get_viewport_rect().size.y:
		queue_free()

func add_letter(letter: String):
	if target_word.begins_with(typed_word + letter):
		typed_word += letter
		$WordLabel.text = "[color=green]" + typed_word + "[/color]" + target_word.substr(typed_word.length())
		if typed_word == target_word:
			destroy_enemy()  # Só chama destroy_enemy quando o inimigo for destruído

func destroy_enemy():
	# Instancia o efeito de explosão
	var effect := plEnemyExplosion.instantiate()
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)

	# Reproduz o som de explosão
	if explosion_sound:
		# Clona o som para que continue a tocar mesmo após remover o inimigo
		var sound_clone := explosion_sound.duplicate()
		get_tree().current_scene.add_child(sound_clone)
		sound_clone.play()

	# Emite o sinal de que o inimigo foi destruído
	emit_signal("destroyed")
	Signals.emit_signal("on_score_increment", 1)

	# Remove o inimigo imediatamente
	queue_free()

func _on_ShootTimer_timeout():
	shoot_letter()

func shoot_letter():
	if letter_scene:
		# Define os ângulos em graus (entre -30 e 30 graus)
		var angles_degrees = [110, 100, 90, 80, 70]  # Exemplo de ângulos
		# Converte os ângulos para radianos
		var angles = []
		for angle_deg in angles_degrees:
			angles.append(deg_to_rad(angle_deg))  # Converte graus para radianos

		# Dispara os projéteis nos ângulos definidos
		for angle in angles:
			var letter_projectile = letter_scene.instantiate()
			letter_projectile.position = $LettersSpawner.global_position
			letter_projectile.direction = Vector2.from_angle(angle)
			get_parent().add_child(letter_projectile)

func _on_shoot_timer_timeout() -> void:
	pass  # Replace with function body.
