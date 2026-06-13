extends Area2D

var jugador_cerca = false

func _ready():
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()

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
			
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.cerrar_dialogo()

func _input(event):
	if jugador_cerca and (event.is_action_pressed("ui_accept") or event.is_action_pressed("interactuar")):
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
			
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		
		if Global.llave_casa_roja == false:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("La puerta está cerrada. Hay una nota: 'Fui a hacer trámites, búscame si necesitas entrar. Atte: El Mago'")
		else:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Usaste la Llave Roja y abriste la cerradura!")
			
			if has_node("AvisoFlotante"):
				$AvisoFlotante.hide()
			
			await get_tree().create_timer(2.0).timeout
			
			Global.destino_puerta = "viene_de_afuera_casa_roja"
			get_tree().change_scene_to_file("res://interior_casa_roja.tscn")
