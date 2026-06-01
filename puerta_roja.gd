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
			nodo_dialogo.cerrar_dialogo()

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
			# LA PUERTA SE ABRE CON TEXTO
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Usaste la Llave Roja y abriste la cerradura!")
			
			# Ocultamos la 'E' para que no estorbe mientras lees
			if has_node("AvisoFlotante"):
				$AvisoFlotante.hide()
			
			# Esperamos 2 segundos para que el jugador alcance a leer el diálogo
			await get_tree().create_timer(2.0).timeout
			
			# 1. Le decimos al Global de dónde venimos
			Global.destino_puerta = "viene_de_afuera_casa_roja"
			# 2. Viajamos al interior de la casa
			get_tree().change_scene_to_file("res://interior_casa_roja.tscn")
