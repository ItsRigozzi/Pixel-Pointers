extends Area2D

@export_file("*.tscn") var escena_destino
@export var nombre_puerta: String = ""

func _on_body_entered(body):
	if body.name == "Jugador" and escena_destino != "":
		if nombre_puerta != "":
			Global.destino_puerta = nombre_puerta
			
		get_tree().call_deferred("change_scene_to_file", escena_destino)
