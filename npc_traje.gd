extends StaticBody2D

var jugador_cerca = false

func _ready():
	# Ocultamos la 'E' al iniciar
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		intentar_hablar()

func intentar_hablar():
	var jugador = get_tree().current_scene.get_node_or_null("Jugador")
	if not jugador: return

	# 1. Calculamos desde dónde le hablas
	var vector_hacia_jugador = jugador.global_position - global_position
	var angulo = vector_hacia_jugador.angle()
	
	# 2. Giramos al NPC
	if angulo > -PI/4 and angulo <= PI/4:
		girar_npc("derecha")
	elif angulo > PI/4 and angulo <= 3*PI/4:
		girar_npc("abajo")
	elif angulo > -3*PI/4 and angulo <= -PI/4:
		girar_npc("arriba")
	else:
		girar_npc("izquierda")

func girar_npc(direccion):
	# Cambiamos la pose en el Spritesheet según la dirección
	if direccion == "abajo":
		$Sprite2D.frame = 0
	elif direccion == "izquierda":
		$Sprite2D.frame = 4
	elif direccion == "derecha":
		$Sprite2D.frame = 8
	elif direccion == "arriba":
		$Sprite2D.frame = 12
		
	# Escondemos la E para que no estorbe al leer
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()
		
	# 3. Lanzamos el Lore
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	if nodo_dialogo:
		nodo_dialogo.mostrar_texto("Qué raros están los cofres últimamente... a veces te hacen preguntas de la nada. Por cierto, ten cuidado si buscas al Mago, dicen que está un poco loco.")

# --- SEÑALES DEL SENSOR ---
func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if has_node("AvisoFlotante"):
			$AvisoFlotante.show()

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
			
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.hide()
