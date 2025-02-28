extends Area2D

@export var speed: float = 100.0  # Velocidade do power-up

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	position.y += speed * delta  # Move o power-up para baixo
	if position.y > get_viewport_rect().size.y:
		queue_free()  # Remove o power-up se sair da tela

func _on_area_entered(area):
	if area.name == "Player":
		print("✨ Power-up coletado!")
		area.apply_powerup()  # Aplica o power-up ao player
		queue_free()
