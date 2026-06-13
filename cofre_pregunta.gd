extends Area2D

var jugador_cerca = false

func _ready():
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()
		
	Global.examen_aprobado.connect(_al_aprobar_examen)

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		abrir_cofre()

func abrir_cofre():
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()
		
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	var pantalla_examen = get_tree().current_scene.get_node_or_null("CapaInterfaz/PantallaExamen")
	
	if Global.cofre_herreria_abierto == false:
		if pantalla_examen:
			pantalla_examen.iniciar_examen_para_nivel(2)
	else:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("El cofre está vacío. Ya tomaste lo que había dentro.")

func _al_aprobar_examen():
	if Global.cofre_herreria_abierto == false:
		Global.cofre_herreria_abierto = true 
		
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Acertijo resuelto! Encontraste una nota con información útil.")

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if has_node("AvisoFlotante") and Global.cofre_herreria_abierto == false:
			$AvisoFlotante.show()

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
			
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.cerrar_dialogo()
