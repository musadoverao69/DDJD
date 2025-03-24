extends Node2D

# Chamado quando o nó entra na árvore de cena pela primeira vez
func _ready() -> void:
	# Verificar se o sinal já está conectado antes de conectar
	if not $Button.is_connected("pressed", Callable(self, "_on_button_pressed")):
		$Button.connect("pressed", Callable(self, "_on_button_pressed"))

# Método chamado quando o botão é pressionado
func _on_button_pressed() -> void:
	# Carregar a cena do menu
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
