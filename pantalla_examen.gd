extends CanvasLayer

@onready var texto_pregunta = $FondoPregunta/TextoPregunta
@onready var texto_a = $BotonA/TextoA
@onready var texto_b = $BotonB/TextoB
@onready var texto_c = $BotonC/TextoC
@onready var mensaje_feedback = $MensajeFeedback

# Las variables de tu cartel
@onready var cartel_progreso = $CartelProgreso
@onready var texto_progreso = $CartelProgreso/TextoProgreso
@onready var numero_progreso = $CartelProgreso/NumeroProgreso
func _ready():
	hide()

func cargar_pregunta_prueba():
	texto_pregunta.text = "¿Qué almacena exactamente una variable de tipo puntero en C?"
	texto_a.text = "A) La dirección de memoria de otra variable." 
	texto_b.text = "B) El valor de un dato entero o decimal."
	texto_c.text = "C) La cantidad de memoria RAM del programa."

func iniciar_examen():
	cargar_pregunta_prueba() 
	mensaje_feedback.text = "" 
	
	# 2. Asegurarnos de que todo se vea bien al abrir la PC
	$FondoPregunta.show()
	$BotonA.show()
	$BotonB.show()
	$BotonC.show()
	cartel_progreso.hide() # Escondemos el cartel por si acaso
	
	show()                   
	get_tree().paused = true 

# --- SEÑALES DE LOS BOTONES ---

func _on_boton_a_pressed():
	# 3. Escondemos la pregunta y los botones inmediatamente
	$FondoPregunta.hide()
	$BotonA.hide()
	$BotonB.hide()
	$BotonC.hide()
	mensaje_feedback.hide()
	
	# 4. ¡DESCONGELAMOS EL JUEGO AL INSTANTE! (El jugador ya puede caminar)
	get_tree().paused = false
	
	# 5. Mostramos tu mini-cartel en la esquina
	cartel_progreso.show()
	texto_progreso.text = "¡Correcto!\nSigue así."
	numero_progreso.text = "1/3" 
	
	# 6. Temporizador: Esperamos 3 segundos reales 
	await get_tree().create_timer(3.0).timeout
	
	# 7. Pasaron los 3 segundos, escondemos el cartel y cerramos la escena
	cartel_progreso.hide()
	hide()

func _on_boton_b_pressed():
	# 1. Mostramos el mensaje de error
	mensaje_feedback.text = "Incorrecto. Un puntero no almacena el dato en sí. ¡Inténtalo de nuevo!"
	
	# 2. Esperamos 2 segundos. 
	# (Usamos 'true' al final porque aquí el juego SIGUE EN PAUSA)
	await get_tree().create_timer(4.0, true).timeout
	
	# 3. Borramos el texto para limpiar la pantalla
	mensaje_feedback.text = ""

func _on_boton_c_pressed():
	# 1. Mostramos el mensaje de error
	mensaje_feedback.text = "Incorrecto. No tiene relación con la memoria RAM total. ¡Piénsalo bien!"
	
	# 2. Esperamos 2 segundos
	await get_tree().create_timer(4.0, true).timeout
	
	# 3. Borramos el texto
	mensaje_feedback.text = ""
