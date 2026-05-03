extends StaticBody2D

var jugador_cerca = false

func _ready():
	$AvisoFlotante.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		
		# USAMOS EL % PARA ENCONTRARLA AL INSTANTE
		var caja_dialogo = get_node_or_null("%CajaDialogo")
		
		if caja_dialogo:
			caja_dialogo.mostrar_texto("Paso bloqueado. ¡Debes ir a tu cuarto y aprobar el examen en la PC primero!")
		else:
			print("Error: No encontré la CajaDialogo")
			
# Estas dos funciones las conectaremos ahora
func _on_sensor_muro_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		$AvisoFlotante.show()

func _on_sensor_muro_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		$AvisoFlotante.hide()
		
		# También usamos el % aquí para esconderla
		var caja_dialogo = get_node_or_null("%CajaDialogo")
		if caja_dialogo:
			caja_dialogo.hide()
