extends Node2D

func _ready():
	var camara = $Jugador/Camera2D
	
	if camara:
		# Mide con la regla en la pantalla 2D y ajusta estos números
		camara.limit_left = -400  
		camara.limit_right = 400
		camara.limit_bottom = 300
		camara.limit_top = -300
