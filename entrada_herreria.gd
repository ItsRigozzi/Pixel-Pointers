extends Area2D

var jugador_cerca = false

func _ready():
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()

func _process(_delta):
	# Si estás cerca y presionas la 'E'
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		
		# Le decimos a la memoria global que queremos entrar
		Global.destino_puerta = "entrar_herreria"
		
		# Viajamos a la herrería
		get_tree().call_deferred("change_scene_to_file", "res://interior_herreria.tscn")

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if has_node("AvisoFlotante"):
			$AvisoFlotante.show()

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
