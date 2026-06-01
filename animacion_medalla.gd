extends CanvasLayer

# Declaramos los 3 elementos visuales
@onready var fondo = $Fondo
@onready var icono = $IconoMedalla
@onready var texto = $Texto

func _ready():
	hide()

# --- CAMBIO 1: Añadimos 'mensaje' a la función ---
func mostrar_recompensa(textura_medalla, mensaje = "¡Has obtenido una Insignia!"):
	
	# 1. Ponemos la imagen de la medalla
	icono.texture = textura_medalla
	# --- CAMBIO 2: Cambiamos el texto en pantalla por el mensaje recibido ---
	texto.text = mensaje 
	
	# 2. Congelamos el juego y mostramos la pantalla
	get_tree().paused = true
	show()
	
	# 3. Hacemos transparentes a los elementos (no al CanvasLayer)
	fondo.modulate.a = 0.0
	icono.modulate.a = 0.0
	texto.modulate.a = 0.0
	
	# Preparamos el tamaño de la recompensa
	icono.scale = Vector2(0.5, 0.5)
	icono.pivot_offset = icono.size / 2
	
	# 4. CREAMOS LA ANIMACIÓN (Tween)
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# --- APARECER (Fade In) ---
	tween.set_parallel(true) # Esto hace que todo lo de abajo se anime al mismo tiempo
	tween.tween_property(fondo, "modulate:a", 1.0, 0.5)
	tween.tween_property(texto, "modulate:a", 1.0, 0.5)
	tween.tween_property(icono, "modulate:a", 1.0, 0.5)
	tween.tween_property(icono, "scale", Vector2(1.2, 1.2), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	# --- ESPERAR ---
	tween.set_parallel(false) # Apagamos el paralelo para que espere
	tween.tween_interval(3.0) # Espera 3 segundos
	
	# --- DESAPARECER (Fade Out) ---
	tween.set_parallel(true) # Volvemos a encender paralelo
	tween.tween_property(fondo, "modulate:a", 0.0, 0.5)
	tween.tween_property(texto, "modulate:a", 0.0, 0.5)
	tween.tween_property(icono, "modulate:a", 0.0, 0.5)
	
	# --- CERRAR ---
	tween.set_parallel(false)
	tween.tween_callback(finalizar_animacion)

func finalizar_animacion():
	hide()
	get_tree().paused = false
