extends StaticBody2D

# 1. Cargar las 4 imágenes (¡Asegúrate de que estas rutas sean correctas en tu proyecto!)
const TEXTURA_ABAJO = preload("res://madre_abajo.png")
const TEXTURA_ARRIBA = preload("res://madre_arriba.png")
const TEXTURA_IZQUIERDA = preload("res://madre_izquierda.png")
const TEXTURA_DERECHA = preload("res://madre_derecha.png")

# Referencia al nodo visual
@onready var sprite_visual = $SpriteVisual

var jugador_en_rango = false

func _ready():
	sprite_visual.texture = TEXTURA_IZQUIERDA
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide() # Ocultar al inicio
	
	# Conectamos la señal global para que escuche cuando termina un examen
	Global.examen_aprobado.connect(_activar_dialogo_automatico)

func _process(_delta):
	# Si el jugador presiona interactuar y está en el área
	if jugador_en_rango and Input.is_action_just_pressed("interactuar"):
		intentar_hablar()

func intentar_hablar():
	# Buscar al jugador en el mapa principal (asegúrate de que el nodo se llame "Jugador")
	var jugador = get_tree().current_scene.get_node_or_null("Jugador")
	if not jugador: return

	# Calcular el ángulo entre la madre y el jugador
	var vector_hacia_jugador = jugador.global_position - global_position
	var angulo = vector_hacia_jugador.angle()
	
	# Determinar la dirección basada en el ángulo (en radianes)
	if angulo > -PI/4 and angulo <= PI/4:
		hablar_exito("derecha")
	elif angulo > PI/4 and angulo <= 3*PI/4:
		hablar_exito("abajo")
	elif angulo > -3*PI/4 and angulo <= -PI/4:
		hablar_exito("arriba")
	else:
		bloquear_interaccion() # Si está a la izquierda

func hablar_exito(direccion):
	print("Hablando con éxito desde: ", direccion)
	if direccion == "derecha": sprite_visual.texture = TEXTURA_DERECHA
	elif direccion == "abajo": sprite_visual.texture = TEXTURA_ABAJO
	elif direccion == "arriba": sprite_visual.texture = TEXTURA_ARRIBA
	
	# Buscamos AMBAS interfaces en la escena
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	var pantalla_examen = get_tree().current_scene.get_node_or_null("CapaInterfaz/PantallaExamen")
	
	if has_node("AvisoFlotante"):
		$AvisoFlotante.hide() # Ocultamos la E
		
	# --- NUEVO: VERIFICAMOS SI YA TE GRADUASTE DEL NIVEL 1 ---
	if Global.nivel_1_aprobado == true:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Qué orgullo, ya eres todo un profesional! Sigue tu viaje con cuidado.")
		return # El 'return' hace que el código se detenga aquí y no abra el examen
	
	# --- LÓGICA DE TURNOS Y BLOQUEO ---
	if Global.preguntas_respondidas_nivel == 0:
		# Aún no ha ido a la PC
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("Hijo, sube a tu cuarto y usa la PC para tu primera lección.")
			
	elif Global.preguntas_respondidas_nivel == 1:
		# ¡Su turno! Ya hizo la PC, ahora le toca a ella
		if pantalla_examen:
			pantalla_examen.iniciar_examen()
			
	else:
		# Si le hablas después de ganarle, te recuerda a dónde ir
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Excelente! Ya estás preparado. Ve al camino principal y demuestra lo que sabes.")
			
func bloquear_interaccion():
	print("No puedes hablarle desde ahí, la mesa está en medio.")

# Función que se activa sola al ganar el examen
func _activar_dialogo_automatico():
	# Verificamos si la pregunta que acaba de responder es la número 2 (la de la madre)
	if Global.preguntas_respondidas_nivel == 2:
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Excelente! Ya estás preparado. Ve al camino principal y demuestra lo que sabes para avanzar al siguiente pueblo.")

# Señales de entrada y salida
func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_en_rango = true
		if has_node("AvisoFlotante"):
			$AvisoFlotante.show() # Mostrar la "E"

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_en_rango = false
		if has_node("AvisoFlotante"):
			$AvisoFlotante.hide() # Ocultar la "E"
		
		# Buscar la Caja de Diálogo y ocultarla también
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.hide()
