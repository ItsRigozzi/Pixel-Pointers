extends Node2D

func _ready():
	var camara = $Jugador/Camera2D
	
	if camara:
		# Mide con la regla en la pantalla 2D y ajusta estos números
		camara.limit_left = -400  
		camara.limit_right = 400
		camara.limit_bottom = 300
		camara.limit_top = -300
		
	if Global.punto_aparicion != "":
		# Busca la marca X que le dijimos
		var punto = get_node_or_null(Global.punto_aparicion)
		if punto:
			# Teletransporta al jugador a esa marca
			$Jugador.global_position = punto.global_position
			
		# Limpia la memoria para que no reaparezca aquí por error después
		Global.punto_aparicion = ""
