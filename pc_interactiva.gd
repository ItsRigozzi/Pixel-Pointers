extends Area2D

var jugador_cerca = false

func _ready():
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()
	
	Global.examen_aprobado.connect(_activar_dialogo_automatico)

func _activar_dialogo_automatico():
	if Global.preguntas_respondidas_nivel == 1:
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Examen superado! Has dado tu primer paso. Baja a la sala para hablar con mamá.")
		else:
			print("ERROR: No encontré la CajaDialogo")

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
		
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CajaDialogo")
		var pantalla_examen = get_tree().current_scene.get_node_or_null("PantallaExamen")

		if Global.nivel_1_aprobado == true:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Ya estudiaste todo por hoy. ¡El Nivel 2 te espera!")
			return

		if Global.preguntas_respondidas_nivel == 0:
			if pantalla_examen:
				pantalla_examen.iniciar_examen()
			else:
				print("ERROR: No encontré la PantallaExamen")
				
		else:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Ya completaste esta lección en la PC. Ve a hablar con mamá o busca la siguiente.")
			else:
				print("ERROR: No encontré la CajaDialogo")

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
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
