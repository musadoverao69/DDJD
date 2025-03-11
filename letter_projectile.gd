extends Area2D

@export var speed: float = 200.0
var direction: Vector2
var letter: String

func _ready():
	$Label.text = letter  # Define a letra do projétil
	connect("body_entered", Callable(self, "_on_body_entered"))  

func _process(delta):
	position += direction * speed * delta  # Move a letra

	# Remove a letra se sair da tela
	if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("🚀 Letra colidiu com o player!")
		queue_free()  # Remove o projétil ao colidir com o player


func _on_area_entered(area):
	if area.is_in_group("player"):
		queue_free()  # Remove o projétil ao colidir com o player
