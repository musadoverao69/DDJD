extends Area2D

@export var move_distance := 200  # Distância total do movimento
@export var move_speed := 2.0  # Velocidade do movimento
@export var max_health := 100  # Vida máxima do boss
var current_health := max_health  # Vida atual do boss

var direction := 1  # 1 = direita, -1 = esquerda

func _ready():
	await get_tree().process_frame
	move_boss()

func move_boss():
	var tween = create_tween()
	var target_position = position.x + (move_distance * direction)

	tween.tween_property(self, "position:x", target_position, move_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	direction *= -1  # Inverter direção
	move_boss()  # Repetir movimento

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	queue_free()  # Remove o boss do jogo quando a vida chega a 0
	print("Boss derrotado!")

func shake_appearance() -> void:
	var original_position = global_position
	print('oioi')
	for i in range(8):
		global_position = original_position + Vector2(randf_range(-5, 5), randf_range(-5, 5))
		await get_tree().create_timer(0.035).timeout
	global_position = original_position
