extends StaticBody2D

func _process(_delta):
	if Global.preguntas_respondidas_nivel >= 3:
		queue_free()
