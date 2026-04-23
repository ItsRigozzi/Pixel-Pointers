extends Control

func _on_boton_iniciar_pressed():
	# Cambia esto si tu escena de intro se llama diferente
	get_tree().change_scene_to_file("res://intro_narrativa.tscn")

func _on_boton_salir_pressed():
	get_tree().quit()
