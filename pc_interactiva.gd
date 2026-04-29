extends Area2D

var jugador_cerca = false

func _ready():
	# 1. Escondemos la 'E' apenas empieza el juego
	$AvisoFlotante.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		print("¡Has encendido la PC! Aquí cargaremos el cuestionario pronto.")
		# Aquí luego pondremos el código para abrir la interfaz de preguntas

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		# 2. Mostramos la 'E' cuando el jugador toca el área invisible
		$AvisoFlotante.show() 

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		# 3. Volvemos a esconder la 'E' cuando el jugador se aleja
		$AvisoFlotante.hide()
