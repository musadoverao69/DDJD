extends Area2D

@export var max_health := 100  # Vida máxima do boss
var current_health := max_health  # Vida atual do boss

@export var projectile_scene: PackedScene  # Cena do projétil
@export var shoot_interval: float = 2.0  # Intervalo entre disparos (em segundos)
@export var projectile_speed: float = 200.0  # Velocidade dos projéteis
@export var shoot_offset: Vector2 = Vector2(0, 158)  # Deslocamento vertical (20 pixels para baixo)

var is_active: bool = false  # Controla se o boss está ativo e pode atirar

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
	emit_signal("boss_defeated")  # Emite o sinal de que o boss foi derrotado
	queue_free()  # Remove o boss do jogo quando a vida chega a 0
	print("Boss derrotado!")

func _on_shoot_timer_timeout():
	if is_active and projectile_scene:
		var projectile = projectile_scene.instantiate()  # Instancia o projétil
		projectile.position = $Sprite2D.global_position + shoot_offset  # Aplica o deslocamento
		
		# Define uma direção aleatória dentro de um cone de 30 graus para baixo
		var random_angle = deg_to_rad(randf_range(-30, 30))  # Ângulo aleatório entre -15 e 15 graus
		projectile.direction = Vector2.DOWN.rotated(random_angle)  # Rotaciona a direção para baixo
		projectile.speed = projectile_speed  # Define a velocidade do projétil
		
		get_parent().add_child(projectile)  # Adiciona o projétil à cena

# Método para ativar o boss (chame isso quando a sétima wave for concluída)
func activate():
	self.visible = true  # Torna o boss visível
	is_active = true  # Ativa o boss
	$ShootTimer.start()  # Inicia o timer para atirar
	print("Boss ativado! Começando a atirar.")
