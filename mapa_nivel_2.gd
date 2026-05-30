extends Node2D

func _ready():
	# 1. Recepción desde el interior de la Frutería
	if Global.destino_puerta == "afuera_fruteria":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Fruteria")
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		# Limpiamos la memoria para que no reaparezca aquí por error
		Global.destino_puerta = ""
		
	# 2. Recepción desde el Nivel 1 (Pueblo Principal)
	elif Global.destino_puerta == "viene_del_nivel_1":
		
		# ¡CORRECCIÓN VITAL! Solo reiniciamos los puntos y barajamos preguntas al llegar por primera vez
		Global.preguntas_respondidas_nivel = 0
		Global.preparar_preguntas_nivel(2)
		
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Inicio_Nivel1")
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		# Limpiamos la memoria
		Global.destino_puerta = ""
		
	# 3. NUEVO: Recepción saliendo de la Herrería
	elif Global.destino_puerta == "afuera_herreria":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_AfueraHerreria") 
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		# Limpiamos la memoria
		Global.destino_puerta = ""
		
	# 4. ¡AQUÍ ESTÁ LA MAGIA! Recepción saliendo de la Casa Azul
	elif Global.destino_puerta == "afuera_casa_azul":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_AfueraCasaAzul") # El Marker2D que acabas de crear
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		# Limpiamos la memoria
		Global.destino_puerta = ""
