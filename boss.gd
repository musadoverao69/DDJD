extends Area2D

@export var max_health := 100  # Vida máxima do boss
@export var projectile_scene: PackedScene  # Cena do projétil
@export var shoot_interval: float = 2.0  # Intervalo entre disparos (em segundos)
@export var projectile_speed: float = 150.0  # Velocidade dos projéteis
@export var shoot_offset: Vector2 = Vector2(0, 158)  # Deslocamento vertical (20 pixels para baixo)
@export var final_position: Vector2  # Posição final na tela

var current_health := max_health  # Vida atual do boss
var cycle_count := 0
var target_word := "overload"
var typed_word := ""
var enemies_spawned := 0
var enemies_defeated := 0
var is_active: bool = false  # Controla se o boss está ativo e pode atirar
var angles = [
	-PI - PI / 4,       # esquerda superior
	-11 * PI / 8,       # entre esquerda e meio
	-PI - PI / 2,       # direto pra cima
	-13 * PI / 8,       # entre meio e direita
	2 * -PI + PI / 4    # direita superior
]

@onready var word_label := $WordLabel  # Crie esse Label como filho do boss na cena!

signal boss_defeated  # Sinal emitido quando o boss é derrotado

func _ready():
	# Inicialmente, o boss não está ativo
	self.visible = false  # Torna o boss visível
	is_active = false
	$ShootTimer.wait_time = shoot_interval  # Configura o intervalo do timer
	$ShootTimer.stop()  # O timer começa parado
	$ShootTimer.timeout.connect(_on_shoot_timer_timeout)  # Conecta o sinal do timer

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	print("Boss morreu!")  # Depuração
	emit_signal("boss_defeated")  # Emite o sinal de que o boss foi derrotado

	await get_tree().create_timer(1.0).timeout  # Delay 

	get_tree().change_scene_to_file("res://Scenes/VictoryScreen.tscn")  # Muda de cena

	queue_free()  # Agora o boss é removido só depois de trocar a cena




func _on_shoot_timer_timeout():
	if is_active and projectile_scene:
		shoot_burst()  # Agora sem contar e delay, pois será baseado em ângulos

func shoot_burst() -> void:
	for i in range(7):  # Disparar 7 projéteis por vez
		var random_angle = deg_to_rad(randf_range(-35, 35))  # Ângulo aleatório entre -15° e 15°
		shoot_projectile(random_angle)

func shoot_projectile(angle: float):
	var projectile = projectile_scene.instantiate()
	projectile.position = $Sprite2D.global_position + shoot_offset

	projectile.direction = Vector2.DOWN.rotated(angle)  
	projectile.speed = projectile_speed
	get_parent().add_child(projectile)


# Método para ativar o boss (chame isso quando a sétima wave for concluída)
func activate():
	self.visible = true
	is_active = true
	await boss_behavior_loop()

func boss_behavior_loop() -> void:
	while current_health > 0 and cycle_count < 3:
		await shake_appearance()
		
		for i in range(3):
			shoot_burst()
			await get_tree().create_timer(1).timeout
		
		await shake_appearance()
		spawn_enemies(5)

		while enemies_defeated < enemies_spawned:
			await get_tree().process_frame

		cycle_count += 1
		await get_tree().create_timer(1).timeout

	# Após os 3 ciclos, mostra a palavra final para destruir o boss
	show_word_label()

func shake_appearance() -> void:
	var original_position = global_position
	for i in range(8):
		global_position = original_position + Vector2(randf_range(-5, 5), randf_range(-5, 5))
		await get_tree().create_timer(0.08).timeout
	global_position = original_position

func spawn_enemies(count: int) -> void:
	enemies_spawned = count
	enemies_defeated = 0

	for i in range(count):
		var offset = Vector2(randf_range(-200, 200), -100)
		var pos = global_position + offset

		var enemy = preload("res://Scenes/Enemy.tscn").instantiate()
		enemy.position = pos
		enemy.target_word = get_random_word()  # Função auxiliar abaixo
		enemy.add_to_group("enemies")
		enemy.destroyed.connect(_on_enemy_destroyed)

		get_parent().add_child(enemy)

		await get_tree().create_timer(0.8).timeout

func get_random_word() -> String:
	var main := get_tree().current_scene  # Pega o Main.gd
	if main.available_words.is_empty():
		main.available_words = main.words.duplicate()
	
	var index = randi() % main.available_words.size()
	var word = main.available_words[index]
	main.available_words.remove_at(index)
	return word

func _on_enemy_destroyed():
	enemies_defeated += 1

func show_word_label():
	word_label.visible = true
	word_label.text = target_word

func add_letter(character: String):
	if target_word.begins_with(typed_word + character):
		typed_word += character
		word_label.text = "[color=green]" + typed_word + "[/color]" + target_word.substr(typed_word.length())
		if typed_word == target_word:
			die()
