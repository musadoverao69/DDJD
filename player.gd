extends Area2D  # Alterado para Area2D

@onready var sprite := $Sprite2D


@export var speed := 300

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))  # Conecta o sinal

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	position += input_vector.normalized() * speed * delta

	if input_vector.x < 0:
		sprite.frame = 0
	elif input_vector.x > 0:
		sprite.frame = 2
	else: 
		sprite.frame = 1


# Função chamada ao colidir com o inimigo
func _on_area_entered(area):
	if area.is_in_group("enemies"):  # Confirma se o objeto é um inimigo
		print("⚡ Colisão com inimigo! Perdeu uma vida.")
		area.queue_free()  # Destroi o inimigo
		$"/root/Main/HUD".lose_life()  # Reduz uma vida usando o HUD
