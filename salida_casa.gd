extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		# Le avisamos a la memoria que salimos de esta casa
		Global.destino_puerta = "viene_de_adentro_casa_roja"
		# Cambia "pueblo_principal.tscn" por el nombre exacto de tu mapa 1 si es diferente
		get_tree().call_deferred("change_scene_to_file", "res://pueblo_principal.tscn")
