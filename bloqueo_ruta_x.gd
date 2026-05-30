extends StaticBody2D

func _process(_delta):
	# El muro vigila constantemente los puntos del jugador.
	# Apenas el Jefe te aprueba la tercera pregunta (llegas a 3 puntos),
	# este muro se auto-destruye y te deja pasar libremente.
	if Global.preguntas_respondidas_nivel >= 3:
		queue_free()
