extends StaticBody2D

const TEXTURA_ABAJO = preload("res://madre_abajo.png")
const TEXTURA_ARRIBA = preload("res://madre_arriba.png")
const TEXTURA_IZQUIERDA = preload("res://madre_izquierda.png")
const TEXTURA_DERECHA = preload("res://madre_derecha.png")

@onready var sprite_visual = $SpriteVisual

var jugador_en_rango = false

func _ready():
	sprite_visual.texture = TEXTURA_IZQUIERDA
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()
	
	Global.examen_aprobado.connect(_activar_dialogo_automatico)

func _process(_delta):
	if jugador_en_rango and Input.is_action_just_pressed("interactuar"):
		intentar_hablar()

func intentar_hablar():
	var jugador = get_tree().current_scene.get_node_or_null("Jugador")
	if not jugador: return

	var vector_hacia_jugador = jugador.global_position - global_position
	var angulo = vector_hacia_jugador.angle()
	
	if angulo > -PI/4 and angulo <= PI/4:
		hablar_exito("derecha")
	elif angulo > PI/4 and angulo <= 3*PI/4:
		hablar_exito("abajo")
	elif angulo > -3*PI/4 and angulo <= -PI/4:
		hablar_exito("arriba")
	else:
		bloquear_interaccion()

func hablar_exito(direccion):
	print("Hablando con éxito desde: ", direccion)
	if direccion == "derecha": sprite_visual.texture = TEXTURA_DERECHA
	elif direccion == "abajo": sprite_visual.texture = TEXTURA_ABAJO
	elif direccion == "arriba": sprite_visual.texture = TEXTURA_ARRIBA
	
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	var pantalla_examen = get_tree().current_scene.get_node_or_null("CapaInterfaz/PantallaExamen")
	
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide()
		
	if Global.nivel_1_aprobado == true:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Qué orgullo, ya eres todo un profesional! Sigue tu viaje con cuidado.")
		return
	
	if Global.preguntas_respondidas_nivel == 0:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("Hijo, sube a tu cuarto y usa la PC para tu primera lección.")
			
	elif Global.preguntas_respondidas_nivel == 1:
		if pantalla_examen:
			pantalla_examen.iniciar_examen()
			
	else:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Excelente! Ya estás preparado. Ve al camino principal y demuestra lo que sabes.")
			
func bloquear_interaccion():
	print("No puedes hablarle desde ahí, la mesa está en medio.")

func _activar_dialogo_automatico():
	if Global.preguntas_respondidas_nivel == 2:
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Excelente! Ya estás preparado. Ve al camino principal y demuestra lo que sabes para avanzar al siguiente pueblo.")

func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_en_rango = true
		if has_node("AvisoFlotante"):
			$AvisoFlotante.show()

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_en_rango = false
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide()
		
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.cerrar_dialogo()
