extends StaticBody2D

var jugador_cerca = false
var ya_respondio = false
var jugador_nodo = null 
var fase_dialogo = 0 

# NUEVO: El NPC usará esta variable para recordar que te hizo una pregunta
var esperando_resultado = false 

@onready var aviso_e = find_child("AvisoFlotante")
@onready var sprite = $Sprite2D 

func _ready():
	if aviso_e: aviso_e.hide()
	Global.examen_aprobado.connect(_al_aprobar_examen)
	
	if Global.npc_nivel3_respondido == true:
		ya_respondio = true
		fase_dialogo = 2

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		girar_hacia_jugador() 
		hablar()

func girar_hacia_jugador():
	if jugador_nodo == null: return
	var direccion = jugador_nodo.global_position - global_position
	var angulo = rad_to_deg(direccion.angle())
	
	if angulo >= -45 and angulo <= 45:
		sprite.frame = 8 # Derecha
	elif angulo > 45 and angulo <= 135:
		sprite.frame = 0 # Abajo
	elif angulo < -45 and angulo >= -135:
		sprite.frame = 12 # Arriba
	else:
		sprite.frame = 4 # Izquierda

func hablar():
	if aviso_e: aviso_e.hide()
	
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	var pantalla_examen = get_tree().current_scene.get_node_or_null("CapaInterfaz/PantallaExamen")
	
	if ya_respondio == true or fase_dialogo == 2:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Excelente trabajo! Ya demostraste que dominas los punteros.")
		return
		
	if fase_dialogo == 0:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Hola, estudiante! El nivel 3 es un verdadero desafío de memoria dinámica. ¿Estás listo para demostrar lo que sabes? (Presiona E de nuevo)")
		fase_dialogo = 1
		return
		
	if fase_dialogo == 1:
		if pantalla_examen:
			# NUEVO: Le decimos al NPC que se quede esperando tu respuesta
			esperando_resultado = true 
			pantalla_examen.iniciar_examen_para_nivel(3)

func _al_aprobar_examen():
	# NUEVO: En lugar de "jugador_cerca", verificamos si ESTE NPC te hizo la pregunta
	if esperando_resultado == true:
		esperando_resultado = false # Apagamos la espera
		ya_respondio = true
		fase_dialogo = 2 
		Global.npc_nivel3_respondido = true

func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		jugador_nodo = body 
		if aviso_e: aviso_e.show()

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		jugador_nodo = null 
		if aviso_e: aviso_e.hide()
		
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo: nodo_dialogo.cerrar_dialogo()
