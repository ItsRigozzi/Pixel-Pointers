extends Node2D

func _ready():
	InterfazVidas.show()
	
	$Camera2D.make_current()
	
	if Global.punto_aparicion != "":
		var punto = get_node_or_null(Global.punto_aparicion)
		if punto:
			$Jugador.global_position = punto.global_position
			
		Global.punto_aparicion = ""
		
	if Global.destino_puerta == "afuera_casa_inicio":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_PuertaCasa")
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
		
	elif Global.destino_puerta == "viene_del_nivel_2":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Inicio_Nivel2")
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
