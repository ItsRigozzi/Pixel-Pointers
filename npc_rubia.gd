extends StaticBody2D

var jugador_cerca = false

func _ready():
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		interactuar()

func interactuar():
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()
		
	lanzar_dialogo_y_curar()

func lanzar_dialogo_y_curar():
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	if not nodo_dialogo: return
	
	if not Global.rubia_dio_fruta_nivel:
		if Global.vidas_actuales < Global.vidas_maximas:
			nodo_dialogo.mostrar_texto("Te veo un poco pálido por tanto estudiar... ¡Toma esta fruta fresca para recuperar energías!")
		else:
			nodo_dialogo.mostrar_texto("¡Te ves muy fuerte! Pero una fruta extra nunca hace daño. ¡Toma!")
		
		Global.vidas_maximas += 1
		Global.vidas_actuales += 1
		
		if Global.vidas_maximas > 5:
			Global.vidas_maximas = 5
		if Global.vidas_actuales > 5:
			Global.vidas_actuales = 5
			
		InterfazVidas.actualizar_vidas()
		Global.rubia_dio_fruta_nivel = true
	else:
		nodo_dialogo.mostrar_texto("Espero que la fruta te haya gustado. ¡Vuelve mañana!")

func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if has_node("AvisoFlotante"):
			$AvisoFlotante.show()

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
			
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.cerrar_dialogo()
