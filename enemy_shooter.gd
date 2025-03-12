extends Node2D

@export var speed: float = 77.0  # Velocidade do inimigo
@export var letter_scene: PackedScene  # Cena do projétil (letra)

var target_word: String = ""  # Palavra do inimigo
var typed_word: String = ""  # O que o jogador digitou
var player: Area2D

signal destroyed

func _ready():
	$WordLabel.bbcode_enabled = true
	$WordLabel.text = target_word  # Exibir a palavra
	$ShootTimer.wait_time = 8.0
	$ShootTimer.start()  # Inicia o timer de disparo
	$ShootTimer.timeout.connect(_on_ShootTimer_timeout)
	_on_ShootTimer_timeout() # Força o disparo
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
			destroy_enemy()

func destroy_enemy():
	print("Inimigo destruído!")  
	
	# Emite o sinal de que o inimigo foi destruído
	emit_signal("destroyed")
	queue_free()

func _on_ShootTimer_timeout():
	shoot_letter()

func shoot_letter():
	if letter_scene:
		var angles = [-PI - PI / 4, -11 * PI / 8, -PI - PI / 2,-13 * PI / 8,2 * -PI + PI / 4] 
		for angle in angles: 
			var letter_projectile = letter_scene.instantiate()
			letter_projectile.position = $LettersSpawner.global_position
			letter_projectile.letter = String.chr(randi_range(65, 90))  # Letra aleatória (A-Z)
			letter_projectile.direction = Vector2.from_angle(angle) 
			get_parent().add_child(letter_projectile)
		


func _on_shoot_timer_timeout() -> void:
	pass # Replace with function body.
