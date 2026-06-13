extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		Global.destino_puerta = "entra_n3_desde_ruta_k"
		get_tree().call_deferred("change_scene_to_file", "res://mapa_nivel_3.tscn")
