extends Node2D

func _ready():
	# 1. Forzamos a encender la cámara estática de esta casa
	$Camera2D.make_current()

	# 2. MAGIA DE APARICIÓN (Se queda igual, esto funciona perfecto)
	if Global.punto_aparicion != "":
		# Busca la marca X que le dijimos
		var punto = get_node_or_null(Global.punto_aparicion)
		if punto:
			# Teletransporta al jugador a esa marca
			$Jugador.global_position = punto.global_position
			
		# Limpia la memoria para que no reaparezca aquí por error después
		Global.punto_aparicion = ""

	# 3. NUEVO SISTEMA AUTOMÁTICO: Recepción bajando del Cuarto del PC
	if Global.destino_puerta == "salida_cuarto":
		var jugador = get_node_or_null("Jugador")
		# Usamos tu nodo exacto que vimos en la imagen
		var posicion = get_node_or_null("Pos_EscaleraAbajo") 
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		# Limpiamos la memoria para evitar bugs
		Global.destino_puerta = ""
