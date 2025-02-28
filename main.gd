extends Node2D

@export var enemy_scene: PackedScene  # Cena do inimigo
@export var spawn_interval: float = 2.0  # Tempo entre spawns

var spawn_timer: float = 0.0
var words := ["space", "galaxy", "planet", "asteroid", "blackhole"]  # Lista de palavras

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0
		spawn_enemy()

func spawn_enemy():
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector2(randf() * get_viewport_rect().size.x, 0)  # Spawn aleatório no topo
		enemy.target_word = words.pick_random()  # Escolher uma palavra aleatória
		add_child(enemy)
		enemy.add_to_group("enemies")

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var key = event.unicode if event.unicode > 0 else event.keycode
		
		# Verifica se a tecla pressionada é válida
		if key > 0:
			var character = char(key)  # Converte o código em caractere
			for enemy in get_tree().get_nodes_in_group("enemies"):
				if enemy.has_method("add_letter"):  # Garante que o inimigo tem a função
					enemy.add_letter(character)


func _on_home_button_pressed():
	print("🏠 HomeButton pressionado!")  # Debug
	get_tree().paused = false  # Despausa antes de mudar de cena
	var result = get_tree().change_scene_to_file("res://Scenes/Menu.tscn")  # Tenta mudar de cena
	print("Mudança de cena resultado:", result)  # Debug
