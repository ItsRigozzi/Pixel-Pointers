extends Node2D

func _ready():
	# MAGIA DE APARICIÓN (Leer el Cerebro Global)
	if Global.punto_aparicion != "":
		# Busca la marca X que le dijimos (en este caso, Pos_PuertaCasa)
		var punto = get_node_or_null(Global.punto_aparicion)
		if punto:
			# Teletransporta al jugador a esa marca
			$Jugador.global_position = punto.global_position
			
		# Limpia la memoria
		Global.punto_aparicion = ""
