extends Node2D

@export var enemy_scene: PackedScene  # Cena do inimigo
@export var powerup_scene: PackedScene 
@export var spawn_interval: float = 2.0  # Tempo entre spawns

var spawn_timer: float = 0.0
var enemies_destroyed: int = 0
var min_x: float = 20
var max_x: float = 700

var words := [
	"space", "galaxy", "planet", "asteroid", "blackhole",
	"nebula", "starship", "orbit", "cosmos", "supernova",
	"engine", "shader", "prototype", "gameloop", "debug",
	"sprite", "pixelart", "viewport", "collision", "particles",
	"feup", "there", "happy", "tese", "put"]

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0
		spawn_enemy()

func spawn_enemy():
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector2(randf_range(min_x, max_x), 0)  # Spawn aleatório no topo
		enemy.target_word = words.pick_random()  # Escolher uma palavra aleatória
		enemy.add_to_group("enemies")
		enemy.destroyed.connect(_on_enemy_destroyed)
		add_child(enemy)

func _on_enemy_destroyed():
	enemies_destroyed += 1
	if enemies_destroyed % 20 == 0:
		spawn_powerup()

func spawn_powerup():
	if powerup_scene:
		var powerup = powerup_scene.instantiate()
		powerup.position = Vector2(randf() * get_viewport_rect().size.x, 0)

		# Sorteia aleatoriamente entre os tipos de power-ups
		var powerup_type = randi() % 2  # 0 ou 1

		if powerup_type == 0:
			powerup.type = "destroy"  # Power-up que destrói todos os inimigos
		else:
			powerup.type = "invincibility"  # Power-up de invencibilidade
		
		add_child(powerup)
		print("🎁 Power-up liberado: " + ( "Destruir todos" if powerup.type == "destroy" else "Invencibilidade"))



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
