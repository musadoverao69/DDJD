shader_type canvas_item;

void fragment() {
    vec2 uv = UV;
    
    // Reduzimos a frequência multiplicando TIME por um valor menor
    float offset = sin(TIME * 3.14159 * 0.03); // Agora o ciclo dura 4 segundos (2s para cada lado)
    uv.y += offset * 0.10; // Ajuste esse valor para controlar a amplitude do movimento
	uv.x += offset * 0.15;

    COLOR = texture(TEXTURE, uv);
}
