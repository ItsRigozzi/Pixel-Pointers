extends StaticBody2D

@export var nivel_asignado: int = 1 

var jugador_cerca = false
var ya_se_presento = false
var esperando_examen = false 

@onready var aviso_e = find_child("AvisoFlotante")

func _ready():
	if aviso_e:
		aviso_e.hide()
		
	Global.examen_aprobado.connect(_al_aprobar_examen)
	
	if nivel_asignado == 1:
		if Global.nivel_1_aprobado == true or Global.preguntas_respondidas_nivel >= 3:
			queue_free()
			
	elif nivel_asignado == 2:
		if Global.insignias >= 2:
			queue_free()
			
	elif nivel_asignado == 3:
		if Global.insignias >= 3:
			queue_free()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		intentar_hablar()

func intentar_hablar():
	var jugador = get_tree().current_scene.get_node_or_null("Jugador")
	if not jugador: return

	var vector_hacia_jugador = jugador.global_position - global_position
	var angulo = vector_hacia_jugador.angle()
	
	if angulo > -PI/4 and angulo <= PI/4:
		girar_jefe("derecha")
	elif angulo > PI/4 and angulo <= 3*PI/4:
		girar_jefe("abajo")
	elif angulo > -3*PI/4 and angulo <= -PI/4:
		girar_jefe("arriba")
	else:
		girar_jefe("izquierda")

func girar_jefe(direccion):
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
	
	if nivel_asignado == 1:
		if Global.preguntas_respondidas_nivel < 2:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Alto ahí, novato! Aún no dominas lo básico. Ve a tu residencia y repasa tus apuntes primero.")
		elif Global.preguntas_respondidas_nivel == 2:
			if pantalla_examen:
				esperando_examen = true
				pantalla_examen.iniciar_examen()
				
	elif nivel_asignado == 2:
		var aciertos_reales = 0
		if Global.llave_casa_roja == true: 
			aciertos_reales += 1
		if Global.cofre_herreria_abierto == true: 
			aciertos_reales += 1
		
		if Global.insignias >= 2:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Felicidades! Tienes la Medalla. El camino de salida está despejado.")
			return 

		if aciertos_reales < 2:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Aún no estás listo, joven. Llevas " + str(aciertos_reales) + " respuestas de 2. ¡Ve con el Herrero y el Mago!")
			return
			
		if aciertos_reales == 2:
			if ya_se_presento == false:
				if nodo_dialogo:
					nodo_dialogo.mostrar_texto("Veo que superaste a mis aldeanos. Esta es tu prueba final para obtener la Medalla. (Vuelve a presionar la E)")
				ya_se_presento = true
			else:
				if pantalla_examen:
					esperando_examen = true
					pantalla_examen.iniciar_examen_para_nivel(2)

	elif nivel_asignado == 3:
		if Global.trofeo_final_obtenido == true:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Recuerda, tu código es: PIXEL-2026-PRO.\nPresiona ESC, sal del juego y envía tu archivo de datos.")
			return 
			
		if Global.npc_nivel3_respondido == true and Global.npc_traje_n3_respondido == true:
			if ya_se_presento == false:
				if nodo_dialogo:
					nodo_dialogo.mostrar_texto("Veo que superaste a mis dos mejores alumnos en los edificios. ¡Es hora de tu prueba final! (Vuelve a presionar la E)")
				ya_se_presento = true
			else:
				if pantalla_examen:
					esperando_examen = true
					pantalla_examen.iniciar_examen_para_nivel(3)
		else:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Aún no estás listo. Vuelve cuando hayas respondido a las preguntas dentro de los dos edificios.")
			return

func _al_aprobar_examen():
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")

	if nivel_asignado == 1 and esperando_examen == true:
		esperando_examen = false
		Global.insignias += 1
		var medalla_img = load("res://medalla1.png")
		AnimacionMedalla.mostrar_recompensa(medalla_img)
		
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Impresionante! Has demostrado tu valor. Toma esta insignia, el camino es todo tuyo.")
		
		await get_tree().create_timer(4.0).timeout
		queue_free()

	elif nivel_asignado == 2 and esperando_examen == true:
		esperando_examen = false
		Global.insignias += 1
		var medalla_img = load("res://medalla2.png")
		AnimacionMedalla.mostrar_recompensa(medalla_img)
		
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Impresionante! Has demostrado ser digno. Toma esta MEDALLA, he mandado a despejar el bloqueo del camino.")

	elif nivel_asignado == 3 and esperando_examen == true:
		esperando_examen = false
		Global.insignias += 1
		Global.trofeo_final_obtenido = true 
		
		var medalla_img = load("res://medalla3.png") 
		if AnimacionMedalla:
			AnimacionMedalla.mostrar_recompensa(medalla_img, "¡MEDALLA Y TROFEO OBTENIDOS!")
			
		if nodo_dialogo:
			Global.bloqueado = true 
			
			nodo_dialogo.mostrar_texto("¡Extraordinario! Has superado el desafío de la memoria dinámica.\n\nTU CÓDIGO PARA EL AULA VIRTUAL ES: PIXEL-2026-PRO\n\nPresiona ESC, dale a 'Salir del Juego' y envíale al profesor el archivo que aparecerá. ¡Gracias por jugar!")
			
			await get_tree().create_timer(10.0).timeout 
			
			nodo_dialogo.cerrar_dialogo()
			
			Global.bloqueado = false

func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if aviso_e: aviso_e.show()

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if aviso_e: aviso_e.hide()
			
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo: nodo_dialogo.cerrar_dialogo()
