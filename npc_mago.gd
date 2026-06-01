extends StaticBody2D

var jugador_cerca = false
var ya_se_presento = false 

@onready var aviso_e = find_child("AvisoFlotante")

func _ready():
	if aviso_e:
		aviso_e.hide()
		
	Global.examen_aprobado.connect(_al_aprobar_examen)

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		intentar_hablar()

func intentar_hablar():
	var jugador = get_tree().current_scene.get_node_or_null("Jugador")
	if not jugador: return

	var vector_hacia_jugador = jugador.global_position - global_position
	var angulo = vector_hacia_jugador.angle()
	
	if angulo > -PI/4 and angulo <= PI/4:
		girar_npc("derecha")
	elif angulo > PI/4 and angulo <= 3*PI/4:
		girar_npc("abajo")
	elif angulo > -3*PI/4 and angulo <= -PI/4:
		girar_npc("arriba")
	else:
		girar_npc("izquierda")

func girar_npc(direccion):
	if direccion == "abajo":
		$Sprite2D.frame = 0
	elif direccion == "izquierda":
		$Sprite2D.frame = 4
	elif direccion == "derecha":
		$Sprite2D.frame = 4
	elif direccion == "arriba":
		$Sprite2D.frame = 12
		
	if aviso_e:
		aviso_e.hide()
		
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	var pantalla_examen = get_tree().current_scene.get_node_or_null("CapaInterfaz/PantallaExamen")
	
	if Global.llave_casa_roja == true:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("Sigue llenándote de conocimiento, viajero.")
		return 

	if ya_se_presento == false:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("Hola, parece que me buscabas... ¿Qué? ¿Quieres mi llave? Responde esta pregunta y te la daré. (Vuelve a presionar la E)")
		ya_se_presento = true
		return 
		
	if pantalla_examen:
		pantalla_examen.iniciar_examen_para_nivel(2)

func _al_aprobar_examen():
	# Eliminado "if not jugador_cerca" para que la entrega sea garantizada
	if Global.llave_casa_roja == false:
		Global.llave_casa_roja = true
		
		var imagen_llave = load("res://llave.png")
		AnimacionMedalla.mostrar_recompensa(imagen_llave, "¡Has obtenido la Llave!")
		
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("Tienes una mente afilada. Toma esta LLAVE. Quizás te sirva en el pueblo anterior.")

# --- SEÑALES DEL SENSOR ---
func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if aviso_e:
			aviso_e.show()

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if aviso_e:
			aviso_e.hide()
			
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.cerrar_dialogo()
