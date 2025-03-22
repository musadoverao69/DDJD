extends Area2D

@export var speed: float = 200.0  # Velocidade do projétil
var direction: Vector2 = Vector2.DOWN  # Direção do projétil

func _ready():
	# Adiciona o projétil ao grupo "boss_projectiles"
	add_to_group("boss_projectiles")
	
	# Rotaciona o Sprite2D para alinhar com a direção do projétil
	$Sprite2D.rotation = direction.angle() - PI / 2

func _process(delta):
	position += direction * speed * delta  # Move o projétil

	# Remove o projétil se sair da tela
	if position.y > get_viewport_rect().size.y:
		queue_free()
