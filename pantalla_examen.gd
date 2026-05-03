extends CanvasLayer

# Conectamos todos los textos, incluyendo el nuevo MensajeFeedback
@onready var texto_pregunta = $FondoPregunta/TextoPregunta
@onready var texto_a = $BotonA/TextoA
@onready var texto_b = $BotonB/TextoB
@onready var texto_c = $BotonC/TextoC
@onready var mensaje_feedback = $MensajeFeedback # NUEVO NODO

func _ready():
	hide()

func cargar_pregunta_prueba():
	texto_pregunta.text = "¿Qué almacena exactamente una variable de tipo puntero en C?"
	texto_a.text = "A) La dirección de memoria de otra variable." 
	texto_b.text = "B) El valor de un dato entero o decimal."
	texto_c.text = "C) La cantidad de memoria RAM del programa."

func iniciar_examen():
	cargar_pregunta_prueba() 
	mensaje_feedback.text = "" # Limpiamos mensajes anteriores por si vuelve a jugar
	show()                   
	get_tree().paused = true 

func cerrar_examen():
	hide()                    
	get_tree().paused = false 

# --- SEÑALES DE LOS BOTONES ---

func _on_boton_a_pressed():
	# RESPUESTA CORRECTA
	mensaje_feedback.text = "¡Correcto! Sabes de punteros."
	
	# Truco: Esperamos 1.5 segundos para que el jugador alcance a leer.
	# El 'true' es un superpoder para que el temporizador funcione aunque el juego esté en pausa.
	await get_tree().create_timer(1.5, true).timeout
	
	cerrar_examen()

func _on_boton_b_pressed():
	# RESPUESTA INCORRECTA
	mensaje_feedback.text = "Incorrecto. Un puntero no almacena el dato en sí. ¡Inténtalo de nuevo!"

func _on_boton_c_pressed():
	# RESPUESTA INCORRECTA
	mensaje_feedback.text = "Incorrecto. No tiene relación con la memoria RAM total. ¡Piénsalo bien!"
