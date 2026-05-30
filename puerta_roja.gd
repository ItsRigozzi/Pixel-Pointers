extends Area2D

var jugador_cerca = false

func _ready():
	# Ocultamos la 'E' apenas empieza el juego
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		# Mostramos la 'E' cuando el jugador se acerca
		if has_node("AvisoFlotante"):
			$AvisoFlotante.show()

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		# Ocultamos la 'E' cuando se aleja
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
			
		# También cerramos el diálogo si el jugador decide irse caminando
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.hide()

func _input(event):
	if jugador_cerca and (event.is_action_pressed("ui_accept") or event.is_action_pressed("interactuar")):
		# Escondemos la 'E' al leer el cartel
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
			
		# Buscamos tu caja de diálogos real en el mapa principal
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		
		if Global.llave_casa_roja == false:
			# LA PUERTA ESTÁ CERRADA
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("La puerta está cerrada. Hay una nota: 'Fui a hacer trámites, búscame si necesitas entrar. Atte: El Mago'")
			else:
				print("ERROR: No encontré la CajaDialogo")
		else:
			# LA PUERTA SE ABRE (Para el futuro)
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Usaste la llave y abriste la puerta roja!")
			# get_tree().change_scene_to_file("res://interior_casa_roja.tscn")
