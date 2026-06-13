extends StaticBody2D

var jugador_cerca = false

func _ready():
	$AvisoFlotante.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		var caja_dialogo = get_node_or_null("%CajaDialogo")
		
		if caja_dialogo:
			caja_dialogo.mostrar_texto("Consigue la medalla de la zona para pasar al siguiente nivel.")
		else:
			print("Error: No encontré la CajaDialogo")
			
func _on_sensor_muro_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		$AvisoFlotante.show()

func _on_sensor_muro_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		$AvisoFlotante.hide()
		
		var caja_dialogo = get_node_or_null("%CajaDialogo")
		if caja_dialogo:
			caja_dialogo.hide()
