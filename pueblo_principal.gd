extends Node2D

func _ready():
	# 1. Hacemos que los corazones aparezcan
	InterfazVidas.show()
	
	# 2. Forzamos la cámara estática del mapa
	$Camera2D.make_current()
	
	# 3. MAGIA DE APARICIÓN ANTIGUA (Leer el Cerebro Global original)
	if Global.punto_aparicion != "":
		# Busca la marca X que le dijimos
		var punto = get_node_or_null(Global.punto_aparicion)
		if punto:
			# Teletransporta al jugador a esa marca
			$Jugador.global_position = punto.global_position
			
		# Limpia la memoria
		Global.punto_aparicion = ""
		
	# 4. NUEVO SISTEMA DE PUERTAS: Recepción desde la Casa de Inicio
	if Global.destino_puerta == "afuera_casa_inicio":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_PuertaCasa") # Usamos tu nodo real
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		# Limpiamos la memoria
		Global.destino_puerta = ""
		
	# 5. NUEVO SISTEMA DE PUERTAS: Recepción regresando desde el Nivel 2
	elif Global.destino_puerta == "viene_del_nivel_2":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Inicio_Nivel2") # El que creamos en el borde derecho
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		# Limpiamos la memoria
		Global.destino_puerta = ""
