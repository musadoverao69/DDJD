extends Node2D

@export var speed: float = 100.0  # Velocidade do inimigo
@export var letter_scene: PackedScene  # Cena do projétil (letra)
var target_word: String = ""  # Palavra do inimigo
var typed_word: String = ""  # O que o jogador digitou

func _ready():
	$WordLabel.bbcode_enabled = true
	$WordLabel.text = target_word  # Exibir a palavra
	print("Inimigo atirador criado com a palavra:", target_word)
	$ShootTimer.start()  # Inicia o timer de disparo

func _process(delta):
	position.y += speed * delta  # Movimentação para baixo

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
	queue_free()

func _on_ShootTimer_timeout():
	shoot_letter()

func shoot_letter():
	if letter_scene:
		var letter_projectile = letter_scene.instantiate()
		letter_projectile.position = $LettersSpawner.global_position
		letter_projectile.letter = String.chr(randi_range(65, 90))  # Letra aleatória (A-Z)
		get_parent().add_child(letter_projectile)
