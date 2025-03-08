extends Area2D

@export var speed: float = 100.0  # Velocidade do power-up
@export var type: String = "destroy"  # Pode ser "destroy" ou "invincibility"
@onready var sprite := $Sprite2D  # Referência ao Sprite do power-up

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	
	# Muda a imagem do power-up de acordo com o tipo
	if type == "destroy":
		sprite.texture = preload("res://Textures/explosion.png")  
	elif type == "invincibility":
		sprite.texture = preload("res://Textures/shield.png")   

	# Ajustar o tamanho do sprite 
	sprite.scale = Vector2(0.08, 0.08)  

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
