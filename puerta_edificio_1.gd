extends Area2D

var jugador_cerca = false
@onready var aviso_e = find_child("AvisoFlotante")

func _ready():
	if aviso_e: aviso_e.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		Global.destino_puerta = "entra_edificio1_n3"
		
		get_tree().change_scene_to_file("res://interior_edificio_1.tscn")

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if aviso_e: aviso_e.show()

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if aviso_e: aviso_e.hide()
