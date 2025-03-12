extends Label

@export var score: int = 0  # Score a ser exibido junto com a WaveLabel

func _draw():
	var font = get_theme_font("font")
	var text_size = font.get_string_size(text)
	var underline_y = size.y - 5  # Posição da linha (ajuste se necessário)
	var extra_length = 400 #Aumenta a linha 
	
	draw_line(Vector2(0, underline_y), Vector2(text_size.x + extra_length, underline_y), Color(1, 1, 1), 2)
	# Desenha o score abaixo da linha
	var score_text = "SCORE: " + str(score).pad_zeros(6)
	var score_size = font.get_string_size(score_text)
	var score_position = Vector2((text_size.x - score_size.x) / 2, underline_y + 20)  # Posiciona abaixo da linha
	
	draw_string(font, score_position, score_text, HORIZONTAL_ALIGNMENT_CENTER, text_size.x)
