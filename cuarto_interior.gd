extends Node2D

func _ready():
	# 1. Forzamos a encender la cámara estática de esta habitación
	$Camera2D.make_current()
	
	# 2. Nos aseguramos de que los corazones aparezcan en pantalla
	InterfazVidas.show()

	# 3. MAGIA DE APARICIÓN (Para las puertas y escaleras)
	if Global.punto_aparicion != "":
		# Busca la marca X que le dijimos
		var punto = get_node_or_null(Global.punto_aparicion)
		if punto:
			# Teletransporta al jugador a esa marca
			$Jugador.global_position = punto.global_position
			
		# Limpia la memoria para que no reaparezca aquí por error después
		Global.punto_aparicion = ""
