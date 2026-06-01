extends StaticBody2D

@export var rol_npc: String = "examen" 

var jugador_cerca = false
var fase_dialogo = 0 

@onready var aviso_e = find_child("AvisoFlotante")

func _ready():
	if aviso_e: aviso_e.hide()
	Global.examen_aprobado.connect(_al_aprobar_examen)
	
	if rol_npc == "guardia" and Global.insignias >= 2:
		queue_free()
		
	# NUEVO: Si es la profesora de examen y ya la vencimos, bloqueamos el diálogo
	if rol_npc == "examen" and Global.silva_ruta_k_respondida == true:
		fase_dialogo = 2

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		interactuar()

func interactuar():
	if aviso_e: aviso_e.hide()

	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	var pantalla_examen = get_tree().current_scene.get_node_or_null("CapaInterfaz/PantallaExamen")

	# ==========================================
	# LÓGICA 1: SILVA COMO GUARDIA
	# ==========================================
	if rol_npc == "guardia":
		if Global.insignias < 2:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Alto ahí! Por órdenes del Jefe, nadie pasa a la Ruta K sin su Medalla.")
		else:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Oh, tienes la Medalla del Jefe! Mis disculpas, despejaré el camino inmediatamente. ¡Buen viaje!")
			
			await get_tree().create_timer(3.5).timeout
			if nodo_dialogo: nodo_dialogo.cerrar_dialogo()
			queue_free() 

	# ==========================================
	# LÓGICA 2: SILVA COMO EXAMEN
	# ==========================================
	elif rol_npc == "examen":
		# Si ya respondimos o ya tenemos el trofeo
		if fase_dialogo == 2 or Global.trofeo_pucv_obtenido == true:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("¡Sigue tu camino! El nuevo edificio de la PUCV quedará increíble.")
			return

		if fase_dialogo == 0:
			if nodo_dialogo:
				nodo_dialogo.mostrar_texto("Este es el nuevo edificio de la PUCV, está en construcción. Te haré una pregunta de repaso, si fallas no perderás vidas. (Presiona E de nuevo)")
			fase_dialogo = 1
			return

		if fase_dialogo == 1:
			if pantalla_examen:
				Global.examen_seguro = true
				pantalla_examen.iniciar_examen_para_nivel(2)

func _al_aprobar_examen():
	if rol_npc != "examen" or not jugador_cerca or fase_dialogo != 1: 
		return

	Global.examen_seguro = false 
	fase_dialogo = 2
	
	# NUEVO: Guardamos en el Global que ya le respondimos (sea cual sea el premio)
	Global.silva_ruta_k_respondida = true 

	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")

	if Global.vidas_actuales < 4:
		Global.vidas_actuales += 1
		InterfazVidas.actualizar_vidas()
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Correcto! Veo que estabas herido por el viaje, te he curado un corazón. ¡Sigue así!")
	else:
		Global.trofeo_pucv_obtenido = true
		var img_trofeo = load("res://trofeo.png") 
		if AnimacionMedalla:
			AnimacionMedalla.mostrar_recompensa(img_trofeo, "¡OBTUVISTE UN TROFEO!")
			
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Correcto! Has demostrado una excelencia impecable en tu viaje. ¡Toma este TROFEO!")

# --- SENSORES ---
func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if aviso_e: aviso_e.show()

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if aviso_e: aviso_e.hide()
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo: nodo_dialogo.cerrar_dialogo()
