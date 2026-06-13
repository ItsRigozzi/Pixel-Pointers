extends Node2D

func _ready():
	$Camera2D.make_current()
	
	InterfazVidas.show()

	if Global.punto_aparicion != "":
		var punto = get_node_or_null(Global.punto_aparicion)
		if punto:
			$Jugador.global_position = punto.global_position
			
		Global.punto_aparicion = ""
