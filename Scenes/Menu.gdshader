shader_type canvas_item;

void fragment() {
    vec2 uv = UV;
    
    // Cria um efeito de vai e volta com uma onda seno
    float offset = sin(TIME * 3.14159* 0.05); // Alterna entre -1 e 1 a cada ~2 segundos
    uv.x += offset * 0.15; // Multiplica pelo deslocamento desejado

    COLOR = texture(TEXTURE, uv);
}



