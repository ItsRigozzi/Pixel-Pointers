extends Node2D

func _ready():
	InterfazVidas.show()
	
	if has_node("Camera2D"):
		$Camera2D.make_current()
	else:
		print("ADVERTENCIA: No se encontró la Camera2D en la Herrería.")
		
	if Global.destino_puerta == "entrar_herreria":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Entrada") 
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
