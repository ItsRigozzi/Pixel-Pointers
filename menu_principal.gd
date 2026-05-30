extends Control

func _ready():
	# Apagamos los corazones en el menú
	InterfazVidas.hide()

func _on_boton_iniciar_pressed():
	get_tree().change_scene_to_file("res://intro_narrativa.tscn")

func _on_boton_salir_pressed():
	get_tree().quit()
