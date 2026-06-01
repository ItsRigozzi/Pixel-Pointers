extends Area2D

var jugador_cerca = false

func _ready():
	# Ocultamos la 'E' apenas empieza el juego
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()
	
	# Le decimos a la PC que escuche atentamente la señal global
	Global.examen_aprobado.connect(_activar_dialogo_automatico)

func _activar_dialogo_automatico():
	# Verificamos que el jugador acaba de pasar la pregunta 1 (la de la PC)
	if Global.preguntas_respondidas_nivel == 1:
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Examen superado! Has dado tu primer paso. Baja a la sala para hablar con mamá.")
		else:
			print("ERROR: No encontré la CajaDialogo")

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		# Escondemos la letra E para que no estorbe
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
		
		# BUSCAMOS LOS NODOS CON LA RUTA CORREGIDA
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CajaDialogo")
		var pantalla_examen = get_tree().current_scene.get_node_or_null("PantallaExamen")

		# --- NUEVO: VERIFICAMOS SI YA TE GRADUASTE DEL NIVEL 1 ---
		if Global.nivel_1_aprobado == true:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Ya estudiaste todo por hoy. ¡El Nivel 2 te espera!")
			return # El 'return' evita que el código avance y abra la pantalla de examen

		# --- LÓGICA DE TURNOS Y BLOQUEO ---
		if Global.preguntas_respondidas_nivel == 0:
			# ¡Es su turno! Es la primera pregunta del nivel
			if pantalla_examen:
				pantalla_examen.iniciar_examen()
			else:
				print("ERROR: No encontré la PantallaExamen")
				
		else:
			# Si tiene 1, 2 o 3, significa que ya pasó por aquí ¡BLOQUEADO!
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Ya completaste esta lección en la PC. Ve a hablar con mamá o busca la siguiente.")
			else:
				print("ERROR: No encontré la CajaDialogo")

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		# Mostramos la 'E' cuando el jugador toca el área invisible
		if has_node("AvisoFlotante"):
			$AvisoFlotante.show() 

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
		
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.cerrar_dialogo()
