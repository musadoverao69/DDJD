extends Area2D

@export var speed: float = 300.0  # Velocidade do projétil
var direction: Vector2 = Vector2.UP  # Direção do projétil (para cima)

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))  # Conecta o sinal de colisão

func _process(delta):
	position += direction * speed * delta  # Move o projétil

	# Remove o projétil se sair da tela
	if position.y < 0:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemies"):  # Verifica se colidiu com um inimigo
		area.destroy_enemy()  # Destroi o inimigo
		queue_free()  # Remove o projétil da cena
