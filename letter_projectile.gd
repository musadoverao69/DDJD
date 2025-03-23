extends Area2D

@export var speed: float = 120.0
var direction: Vector2

func _ready():
	rotation = direction.angle() - PI / 2
	add_to_group("enemy_projectiles")

func _process(delta):
	position += direction * speed * delta  # Move o projétil

	# Remove se sair da tela
	if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("💥 Projétil colidiu com o player!")
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
