extends Node2D

func _ready():
	# 1. Aseguramos que los corazones del Singleton sean visibles
	InterfazVidas.show()
	
	# 2. Forzamos a encender la cámara fija para ver toda la habitación
	if has_node("Camera2D"):
		$Camera2D.make_current()
	else:
		print("ADVERTENCIA: No se encontró la Camera2D en la Herrería.")
		
	# 3. MAGIA DE APARICIÓN (Para cuando entres desde la calle del Nivel 2)
	# Nota: Más adelante crearemos un Marker2D llamado "Pos_Entrada" en la puerta
	if Global.destino_puerta == "entrar_herreria":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Entrada") 
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
