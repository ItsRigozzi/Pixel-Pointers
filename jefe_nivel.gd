extends StaticBody2D

# --- ESTO APARECERÁ EN EL INSPECTOR (A LA DERECHA) ---
@export var nivel_asignado: int = 1 

var jugador_cerca = false
var ya_se_presento = false

# Usamos find_child para que encuentre la E sin importar la jerarquía
@onready var aviso_e = find_child("AvisoFlotante")

func _ready():
	if aviso_e:
		aviso_e.hide()
		
	Global.examen_aprobado.connect(_al_aprobar_examen)
	
	# Lógica de inicio SOLO PARA EL NIVEL 1 (Desaparecer si ya le ganamos)
	if nivel_asignado == 1:
		if Global.has_property("nivel_1_aprobado") and Global.nivel_1_aprobado == true:
			queue_free()
		elif Global.preguntas_respondidas_nivel >= 3:
			queue_free()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		intentar_hablar()

func intentar_hablar():
	var jugador = get_tree().current_scene.get_node_or_null("Jugador")
	if not jugador: return

	# 1. Calculamos el ángulo
	var vector_hacia_jugador = jugador.global_position - global_position
	var angulo = vector_hacia_jugador.angle()
	
	# 2. Giramos al Jefe
	if angulo > -PI/4 and angulo <= PI/4:
		girar_jefe("derecha")
	elif angulo > PI/4 and angulo <= 3*PI/4:
		girar_jefe("abajo")
	elif angulo > -3*PI/4 and angulo <= -PI/4:
		girar_jefe("arriba")
	else:
		girar_jefe("izquierda")

func girar_jefe(direccion):
	# Respetamos tus frames originales (0, 4, 8, 12). 
	# (Si al girar parece que camina en vez de estar quieto, cámbialos a 1, 5, 9, 13)
	if direccion == "abajo":
		$Sprite2D.frame = 0
	elif direccion == "izquierda":
		$Sprite2D.frame = 4
	elif direccion == "derecha":
		$Sprite2D.frame = 8
	elif direccion == "arriba":
		$Sprite2D.frame = 12
		
	if aviso_e:
		aviso_e.hide()
		
	ejecutar_dialogo()

func ejecutar_dialogo():
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	var pantalla_examen = get_tree().current_scene.get_node_or_null("CapaInterfaz/PantallaExamen")
	
	# ==========================================
	# LÓGICA DEL NIVEL 1
	# ==========================================
	if nivel_asignado == 1:
		if Global.preguntas_respondidas_nivel < 2:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Alto ahí, novato! Aún no dominas lo básico. Ve a tu residencia y repasa tus apuntes primero.")
		elif Global.preguntas_respondidas_nivel == 2:
			if pantalla_examen:
				# Respetamos tu función original de iniciar_examen para el Nivel 1
				pantalla_examen.iniciar_examen()
				
	# ==========================================
	# LÓGICA DEL NIVEL 2
	# ==========================================
	elif nivel_asignado == 2:
		if Global.preguntas_respondidas_nivel >= 3:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Felicidades! Tienes la Medalla. El camino de salida está despejado.")
			return 

		if Global.preguntas_respondidas_nivel < 2:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Aún no estás listo, joven. Ve con el Herrero y el Mago. Vuelve cuando tengas 2 respuestas correctas.")
			return
			
		if Global.preguntas_respondidas_nivel == 2:
			if ya_se_presento == false:
				if nodo_dialogo:
					nodo_dialogo.mostrar_texto("Veo que superaste a mis aldeanos. Esta es tu prueba final para obtener la Medalla. (Vuelve a presionar la E)")
				ya_se_presento = true
			else:
				if pantalla_examen:
					pantalla_examen.iniciar_examen_para_nivel(2)

func _al_aprobar_examen():
	# Si el jugador no está con el Jefe, ignoramos esto
	if not jugador_cerca: return

	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")

	# VICTORIA NIVEL 1 (Se va del camino)
	if nivel_asignado == 1 and Global.preguntas_respondidas_nivel == 3:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Impresionante! Has demostrado tu valor. Toma esta insignia, el camino es todo tuyo.")
		
		# Espera a que termines de leer y luego se quita del camino
		await get_tree().create_timer(4.0).timeout
		queue_free()

	# VICTORIA NIVEL 2 (Se queda sentado)
	elif nivel_asignado == 2 and Global.preguntas_respondidas_nivel == 3:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Impresionante! Has demostrado ser digno. Toma esta MEDALLA, he mandado a despejar el bloqueo del camino.")

# --- SENSORES ---
func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if aviso_e: aviso_e.show()

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if aviso_e: aviso_e.hide()
			
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo: nodo_dialogo.hide()
