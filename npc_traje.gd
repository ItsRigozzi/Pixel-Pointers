extends StaticBody2D

# NUEVO: Define en qué nivel está (por defecto 2)
@export var nivel_ubicacion: int = 2

var jugador_cerca = false
var fase_dialogo = 0 
var esperando_resultado = false 

func _ready():
	# Ocultamos la 'E' al iniciar
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()
		
	Global.examen_aprobado.connect(_al_aprobar_examen)
	
	# NUEVO: Memoria para el Nivel 3
	if nivel_ubicacion == 3 and Global.npc_traje_n3_respondido == true:
		fase_dialogo = 2

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
		
	# 3. Lanzamos el diálogo correspondiente
	hablar()

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

func hablar():
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	var pantalla_examen = get_tree().current_scene.get_node_or_null("CapaInterfaz/PantallaExamen")
	
	# ==========================================
	# LÓGICA NIVEL 2: Solo Lore
	# ==========================================
	if nivel_ubicacion == 2:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("Qué raros están los cofres últimamente... a veces te hacen preguntas de la nada. Por cierto, ten cuidado si buscas al Mago, dicen que está un poco loco.")
		return
		
	# ==========================================
	# LÓGICA NIVEL 3: El chiste y el Examen
	# ==========================================
	elif nivel_ubicacion == 3:
		# Si ya respondiste
		if Global.npc_traje_n3_respondido == true or fase_dialogo == 2:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Mejor sigo esperando... ¿subir las escaleras? no gracias.")
			return
			
		if fase_dialogo == 0:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Oye! Tú eras el que estaba en la plaza, ¿verdad? Te dije que ese mago estaba loco... ¿Te hago una pregunta para pasar el rato? (Presiona E de nuevo)")
			fase_dialogo = 1
			return
			
		if fase_dialogo == 1:
			if pantalla_examen:
				esperando_resultado = true
				pantalla_examen.iniciar_examen_para_nivel(3)

func _al_aprobar_examen():
	# Solo guardamos memoria si estamos en la versión del Nivel 3
	if nivel_ubicacion == 3 and esperando_resultado == true:
		esperando_resultado = false 
		fase_dialogo = 2 
		Global.npc_traje_n3_respondido = true

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
			nodo_dialogo.cerrar_dialogo()
