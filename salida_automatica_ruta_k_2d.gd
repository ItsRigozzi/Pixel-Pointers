extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		Global.destino_puerta = "entra_ruta_k_desde_n2"
		
		get_tree().call_deferred("change_scene_to_file", "res://ruta_k.tscn")
