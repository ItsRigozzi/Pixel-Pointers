extends Area2D

@export var mensaje: String = "Residencia de X"
var jugador_cerca = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$AvisoFlotante.hide()

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		$AvisoFlotante.show()

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		$AvisoFlotante.hide()
		var caja = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if caja: caja.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		var caja = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if caja:
			if caja.visible:
				caja.hide()
			else:
				caja.mostrar_texto("¡Hola! Esta es la casa azul.") # O tu variable mensajee
