extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		if Global.preguntas_respondidas_nivel >= 3 or Global.nivel_1_aprobado == true:
			Global.nivel_1_aprobado = true
			
			Global.destino_puerta = "viene_del_nivel_1"
			
			get_tree().call_deferred("change_scene_to_file", "res://mapa_nivel_2.tscn")
			
		else:
			var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡No puedes irte al Nivel 2! El Jefe del pueblo te está evaluando.")
