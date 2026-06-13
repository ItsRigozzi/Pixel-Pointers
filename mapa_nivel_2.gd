extends Node2D

func _ready():
	if Global.destino_puerta == "afuera_fruteria":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Fruteria")
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
		
	elif Global.destino_puerta == "viene_del_nivel_1":
		Global.preguntas_respondidas_nivel = 0
		Global.preparar_preguntas_nivel(2)
		
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Inicio_Nivel1")
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
		
	elif Global.destino_puerta == "afuera_herreria":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_AfueraHerreria") 
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
		
	elif Global.destino_puerta == "afuera_casa_azul":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_AfueraCasaAzul")
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
