extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		Global.destino_puerta = "sale_edificio2_n3"
		get_tree().call_deferred("change_scene_to_file", "res://mapa_nivel_3.tscn")
