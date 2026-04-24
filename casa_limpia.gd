extends Node2D

func _ready():
	var camara = $Jugador/Camera2D
	
	if camara:
		camara.limit_left = -512
		camara.limit_right = 512
		camara.limit_bottom = 416
		camara.limit_top = -416
