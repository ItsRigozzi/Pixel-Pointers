extends StaticBody2D

var jugador_cerca = false

# --- NOTA ---
# He borrado la variable 'ya_dio_fruta' local.
# Ahora usamos 'Global.rubia_dio_fruta_nivel' para que el juego recuerde
# si ya te dio la fruta, incluso si sales y entras a la frutería.
# ----------

func _ready():
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		interactuar()

func interactuar():
	var jugador = get_tree().current_scene.get_node_or_null("Jugador")
	if not jugador: return

	# --- ZONA DE GIRO (Opcional, si tienes spritesheet) ---
	# var vector = jugador.global_position - global_position
	# var angulo = vector.angle()
	# if angulo > -PI/4 and angulo <= PI/4:
	# 	$Sprite2D.frame = 8 # Derecha
	# elif angulo > PI/4 and angulo <= 3*PI/4:
	# 	$Sprite2D.frame = 0 # Abajo
	# elif angulo > -3*PI/4 and angulo <= -PI/4:
	# 	$Sprite2D.frame = 12 # Arriba
	# else:
	# 	$Sprite2D.frame = 4 # Izquierda
	# ------------------------------------------

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
		
		# REGLA 3: Aumentar la CAPACIDAD máxima y dar la vida
		# (Esto es lo que hace que aparezca un nuevo corazón en pantalla)
		Global.vidas_maximas += 1
		Global.vidas_actuales += 1
		
		# Seguro para que nunca pase de los 5 dibujos físicos que tienes en la interfaz
		if Global.vidas_maximas > 5:
			Global.vidas_maximas = 5
		if Global.vidas_actuales > 5:
			Global.vidas_actuales = 5
			
		# REGLA 4: Actualizar la interfaz
		InterfazVidas.actualizar_vidas()
		
		# REGLA 5: Marcar que ya te dio la fruta
		Global.rubia_dio_fruta_nivel = true
	else:
		nodo_dialogo.mostrar_texto("Espero que la fruta te haya gustado. ¡Vuelve mañana!")

# --- SEÑALES DEL SENSOR ---
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
			nodo_dialogo.hide()
