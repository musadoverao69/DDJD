extends Control

func _ready():
	# Conecta o sinal "pressed" do StartButton ao método "_on_start_button_pressed"
	if not $StartButton.is_connected("pressed", Callable(self, "_on_start_button_pressed")):
		$StartButton.connect("pressed", Callable(self, "_on_start_button_pressed"))
	
	# Conecta o sinal "pressed" do GuideButton ao método "_on_button_pressed"
	var guide_button = $StartButton.get_node("GuideButton")
	if not guide_button.is_connected("pressed", Callable(self, "_on_button_pressed")):
		guide_button.connect("pressed", Callable(self, "_on_button_pressed"))

func _on_start_button_pressed():
	# Carrega a cena principal do jogo
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_button_pressed() -> void:
	# Carrega a cena "guide"
	get_tree().change_scene_to_file("res://Scenes/guide.tscn")
