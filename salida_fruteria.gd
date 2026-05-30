extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		Global.destino_puerta = "afuera_fruteria"
		# El call_deferred hace que Godot espere un milisegundo a terminar la física antes de viajar
		get_tree().call_deferred("change_scene_to_file", "res://mapa_nivel_2.tscn")
