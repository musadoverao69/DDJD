extends Area2D

@export var speed: float = 200.0
var direction: Vector2
var letter: String

func _ready():
	$Label.text = letter  # Define a letra do projétil
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()  # Direção aleatória

func _process(delta):
	position += direction * speed * delta  # Move a letra

	# Remove a letra se sair da tela
	if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()
