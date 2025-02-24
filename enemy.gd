extends Node2D

@export var speed: float = 100.0  # Velocidade da nave inimiga
var target_word: String = ""  # Palavra associada à nave
var typed_word: String = ""  # O que o jogador digitou

func _ready():
	$Label.text = target_word  # Exibir a palavra
	print(target_word)

func _process(delta):
	# Movimentação para baixo
	position.y += speed * delta

	# Remover o inimigo caso saia da tela
	if position.y > get_viewport_rect().size.y:
		queue_free()

# Função para adicionar letras digitadas pelo jogador
func add_letter(letter: String):
	if target_word.begins_with(typed_word + letter):
		typed_word += letter
		$Label.text = "[color=green]" + typed_word + "[/color]" + target_word.substr(typed_word.length())
		if typed_word == target_word:
			destroy_enemy()


func destroy_enemy():
	print("Inimigo destruído!")  # Aqui você pode adicionar explosão e efeitos
	queue_free()

func wrong_input():
	print("")  # Pode piscar vermelho ou outro efeito
