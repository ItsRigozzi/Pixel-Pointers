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
	$AvisoFlotante.hide() # Ocultar al inicio

func _process(_delta):
	# Si el jugador presiona interactuar y está en el área
	if jugador_en_rango and Input.is_action_just_pressed("interactuar"):
		intentar_hablar()

func intentar_hablar():
	# Buscar al jugador en el mapa principal (asegúrate de que el nodo se llame "Jugador")
	var jugador = get_tree().current_scene.get_node("Jugador")
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
	# Cambiar imagen
	if direccion == "derecha": sprite_visual.texture = TEXTURA_DERECHA
	elif direccion == "abajo": sprite_visual.texture = TEXTURA_ABAJO
	elif direccion == "arriba": sprite_visual.texture = TEXTURA_ARRIBA
	
	# 1. Encontrar la Caja de Diálogo en la escena principal
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	
	# 2. Si la encuentra, iniciamos el diálogo
	if nodo_dialogo:
		$AvisoFlotante.hide() # Ocultamos la E mientras habla
		
		# (Asumiendo que tu caja tiene una función como mostrar_texto(mensaje))
		# Ajusta esta línea según cómo programaste tu CajaDialogo originalmente:
		nodo_dialogo.mostrar_texto("¡Hola hijo! Ten cuidado al salir de casa.") 
		
	else:
		print("ERROR: No se encontró la CajaDialogo en la escena.")
func bloquear_interaccion():
	print("No puedes hablarle desde ahí, la mesa está en medio.")

# Estas funciones se crearon cuando conectaste las señales en el Paso 2.2
func _on_area_sensor_body_entered(body):
	if body.name == "Jugador":
		jugador_en_rango = true
		$AvisoFlotante.show() # Mostrar la "E"

func _on_area_sensor_body_exited(body):
	if body.name == "Jugador":
		jugador_en_rango = false
		$AvisoFlotante.hide() # Ocultar la "E"
		
		# Buscar la Caja de Diálogo y ocultarla también
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.hide() 
			# Nota: Si tu caja de diálogo tiene una función especial para cerrarse 
			# (por ejemplo, nodo_dialogo.cerrar() o nodo_dialogo.ocultar()), 
			# úsala en lugar de .hide()
