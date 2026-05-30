extends Area2D

# Al poner @export, estas variables aparecerán mágicamente en el panel del Inspector
@export_file("*.tscn") var escena_destino
@export var nombre_puerta: String = ""

func _on_body_entered(body):
	if body.name == "Jugador" and escena_destino != "":
		# Guardamos en la memoria de dónde venimos
		if nombre_puerta != "":
			Global.destino_puerta = nombre_puerta
			
		# Viajamos automáticamente (call_deferred evita el error rojo de físicas)
		get_tree().call_deferred("change_scene_to_file", escena_destino)
