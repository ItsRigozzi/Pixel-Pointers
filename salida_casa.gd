extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		Global.destino_puerta = "viene_de_adentro_casa_roja"
		get_tree().call_deferred("change_scene_to_file", "res://pueblo_principal.tscn")
