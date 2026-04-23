extends Control

func _ready():
	# Espera 4 segundos y cambia al mapa principal
	await get_tree().create_timer(4.0).timeout
	ir_al_mapa()

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interactuar"):
		ir_al_mapa()

func ir_al_mapa():
	get_tree().change_scene_to_file("res://pueblo_principal.tscn")
