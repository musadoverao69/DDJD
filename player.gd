extends Area2D  # Alterado para Area2D

@onready var sprite := $Sprite2D


@export var speed := 300
var base_speed := 300
var powerup_active := false
var min_x: float = 20
var max_x: float = 700

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))  # Conecta o sinal

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	position += input_vector.normalized() * speed * delta
	
	position.x = clamp(position.x, min_x, max_x)
	
	if powerup_active and Input.is_action_just_pressed("ui_accept"):
		destroy_all_enemies()
		powerup_active = false
		print("💥 Todas as naves inimigas foram destruídas!")
	
	if input_vector.x < 0:
		sprite.frame = 0
	elif input_vector.x > 0:
		sprite.frame = 2
	else: 
		sprite.frame = 1


# Função chamada ao colidir com o inimigo
func _on_area_entered(area):
	if area.is_in_group("enemies"):  
		area.queue_free()  # Destroi o inimigo
		$"/root/Main/HUD".lose_life()  # Reduz uma vida usando o HUD
	
func apply_powerup():
	powerup_active = true
	print("💣 Power-up ativado: Pressione ENTER para destruir todas as naves!")

func destroy_all_enemies():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.destroy_enemy()
