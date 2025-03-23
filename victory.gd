extends Button

func _ready():
	self.pressed.connect(_on_victory_button_pressed)

func _on_victory_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn") 
