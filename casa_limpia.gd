extends Node2D

func _ready():
	$Camera2D.make_current()

	if Global.punto_aparicion != "":
		var punto = get_node_or_null(Global.punto_aparicion)
		if punto:
			$Jugador.global_position = punto.global_position
			
		Global.punto_aparicion = ""

	if Global.destino_puerta == "salida_cuarto":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_EscaleraAbajo") 
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
