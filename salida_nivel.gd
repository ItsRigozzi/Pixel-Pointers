extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		# Magia: Verificamos si tiene las 3 preguntas HOY, O si ya había aprobado el nivel ANTES
		if Global.preguntas_respondidas_nivel >= 3 or Global.nivel_1_aprobado == true:
			
			# Guardamos para toda la eternidad que este nivel ya fue superado
			Global.nivel_1_aprobado = true
			
			# Guardamos en la memoria que vamos hacia el nivel 2
			Global.destino_puerta = "viene_del_nivel_1"
			
			# Viajamos automáticamente al pisar
			get_tree().call_deferred("change_scene_to_file", "res://mapa_nivel_2.tscn")
			
		else:
			# Si intenta escapar sin hacer el examen por primera vez
			var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡No puedes irte al Nivel 2! El Jefe del pueblo te está evaluando.")
			
