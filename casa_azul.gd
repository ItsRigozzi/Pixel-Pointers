extends Node2D

func _ready():
	# 1. Aseguramos que los corazones sean visibles
	if Global.has_method("mostrar_vidas") or (typeof(InterfazVidas) != TYPE_NIL):
		InterfazVidas.show()
	
	# 2. Forzamos la cámara de esta habitación
	if has_node("Camera2D"):
		$Camera2D.make_current()
		
	# 3. Recibimos al jugador al entrar desde el mapa
	if Global.destino_puerta == "entrar_casa_azul":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Entrada") 
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
