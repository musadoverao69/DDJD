extends Area2D

@export var speed: float = 100.0  # Velocidade do power-up
@export var type: String = "destroy"  # Pode ser "destroy" ou "invincibility"

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	position.y += speed * delta  # Move o power-up para baixo
	if position.y > get_viewport_rect().size.y:
		queue_free()  # Remove o power-up se sair da tela



func _on_area_entered(area):
	if area.name == "Player":
		print("✨ Power-up coletado!")
		if type == "destroy":
			area.apply_powerup("destroy")  # Aplica o power-up de destruir todos os inimigos
		elif type == "invincibility":
			area.apply_powerup("invincibility")  # Aplica o power-up de invencibilidade
		queue_free()  # Remove o power-up após ser coletado
