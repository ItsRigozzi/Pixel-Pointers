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
	if Global.pregunta_pc_resuelta == false:
		# --- PREGUNTA 1 (La de la PC) ---
		texto_pregunta.text = "¿Qué almacena exactamente una variable de tipo puntero en C?"
		texto_a.text = "A) La dirección de memoria de otra variable." 
		texto_b.text = "B) El valor de un dato entero o decimal."
		texto_c.text = "C) La cantidad de memoria RAM del programa."
	else:
		# --- PREGUNTA 2 (La de la mamá) ---
		texto_pregunta.text = "¿Qué símbolo se usa para obtener la dirección de memoria de una variable?"
		# Ponemos la correcta en la A para no tener que reprogramar la lógica de ganar:
		texto_a.text = "A) El operador de dirección (&)." 
		texto_b.text = "B) El operador de indirección (*)."
		texto_c.text = "C) El operador de porcentaje (%)."

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
	# Escondemos la pregunta y los botones
	$FondoPregunta.hide()
	$BotonA.hide()
	$BotonB.hide()
	$BotonC.hide()
	mensaje_feedback.hide()
	
	# Descongelamos el juego
	get_tree().paused = false
	cartel_progreso.show()
	texto_progreso.text = "¡Correcto!\nSigue así."
	
	# --- LÓGICA DE PROGRESO ---
	if Global.pregunta_pc_resuelta == false:
		Global.pregunta_pc_resuelta = true # Marcamos la 1 como lista
		numero_progreso.text = "1/3"       # Mostramos 1/3
	else:
		numero_progreso.text = "2/3"       # Si ya estaba lista, mostramos 2/3
		
	# Temporizador de 3 segundos y cerrar
	await get_tree().create_timer(3.0).timeout
	cartel_progreso.hide()
	hide()

func _on_boton_b_pressed():
	# Revisamos en qué pregunta estamos para dar el feedback correcto
	if Global.pregunta_pc_resuelta == false:
		# Error para la Pregunta 1
		mensaje_feedback.text = "Incorrecto. Un puntero no almacena el dato en sí. ¡Inténtalo de nuevo!"
	else:
		# Error para la Pregunta 2
		mensaje_feedback.text = "Incorrecto. El asterisco (*) sirve para desreferenciar (acceder al valor), no para la dirección."
	
	# Esperamos 2 segundos manteniendo la pausa
	await get_tree().create_timer(2.0, true).timeout
	
	# Borramos el texto
	mensaje_feedback.text = ""

func _on_boton_c_pressed():
	# Revisamos en qué pregunta estamos
	if Global.pregunta_pc_resuelta == false:
		# Error para la Pregunta 1
		mensaje_feedback.text = "Incorrecto. No tiene relación con la memoria RAM total. ¡Piénsalo bien!"
	else:
		# Error para la Pregunta 2
		mensaje_feedback.text = "Incorrecto. El porcentaje (%) es un operador matemático (módulo). ¡Inténtalo de nuevo!"
	
	# Esperamos 2 segundos manteniendo la pausa
	await get_tree().create_timer(2.0, true).timeout
	
	# Borramos el texto
	mensaje_feedback.text = ""
