extends Node2D

@export var speed: float = 100.0  # Velocidade da nave inimiga
var target_word: String = ""  # Palavra associada à nave
var typed_word: String = ""  # O que o jogador digitou
var player: Area2D

var plEnemyExplosion := preload("res://Scenes/EnemyExplosion.tscn")

signal destroyed

func _ready():
	$WordLabel2.bbcode_enabled = true
	$WordLabel2.text = target_word  # Exibir a palavra
	player = get_tree().get_first_node_in_group("player")  # Obtém referência ao player

func _process(delta):
	# Movimentação para baixo
	if player:
		var direction = (player.position - position).normalized()
		position += direction * speed * delta  # Move na direção do player
	# Remover o inimigo caso saia da tela
	if position.y > get_viewport_rect().size.y:
		queue_free()

# Função para adicionar letras digitadas pelo jogador
func add_letter(letter: String):
	if target_word.begins_with(typed_word + letter):
		typed_word += letter
		$WordLabel2.text = "[color=green]" + typed_word + "[/color]" + target_word.substr(typed_word.length())
		if typed_word == target_word:
			destroy_enemy()


func destroy_enemy():
	var effect := plEnemyExplosion.instantiate()
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)
	
	# Emite o sinal de que o inimigo foi destruído
	emit_signal("destroyed")  # Esta linha deve ser adicionada
	
	Signals.emit_signal("on_score_increment", 1)

	queue_free()  # Remove o inimigo



func wrong_input():
	$WordLabel2.text = "[color=red]" + typed_word + "[/color]" + target_word.substr(typed_word.length())
