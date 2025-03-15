extends Node2D

@export var speed: float = 50.0  # Velocidade de descida do boss
@onready var health = 10  # Vida do Boss (podes ajustar)
@onready var sprite := $Sprite2D  # Certifica-te que tens um Sprite2D dentro do Boss
@onready var collision := $CollisionShape2D  # Certifica-te que tens uma colisão

func _process(delta):
	# Move o Boss para baixo até um certo ponto
	if global_position.y < 100:
		global_position.y += speed * delta

func take_damage(amount):
	health -= amount
	print("Boss sofreu dano! Vida restante:", health)
	
	if health <= 0:
		die()

func die():
	print("💀 O Boss foi derrotado!")
	queue_free()  # Remove o boss ao morrer
