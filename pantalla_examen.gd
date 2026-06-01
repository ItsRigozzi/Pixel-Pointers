extends CanvasLayer

@onready var texto_pregunta = $FondoPregunta/TextoPregunta
@onready var texto_a = $BotonA/TextoA
@onready var texto_b = $BotonB/TextoB
@onready var texto_c = $BotonC/TextoC
@onready var mensaje_feedback = $MensajeFeedback
@onready var cartel_progreso = $CartelProgreso
@onready var texto_progreso = $CartelProgreso/TextoProgreso
@onready var numero_progreso = $CartelProgreso/NumeroProgreso
@onready var boton_entendido = $BotonEntendido

var pregunta_actual = {}
var respuesta_correcta_texto = ""
var opcion_a = ""
var opcion_b = ""
var opcion_c = ""

func _ready():
	hide()

func iniciar_examen_para_nivel(numero_nivel):
	if Global.nivel_actual != numero_nivel:
		Global.nivel_actual = numero_nivel
		Global.preguntas_disponibles.clear()
		
	iniciar_examen()

func iniciar_examen():
	# Bloqueamos al jugador al abrir el examen
	Global.bloqueado = true
	
	if Global.preguntas_disponibles.size() == 0:
		Global.preparar_preguntas_nivel(Global.nivel_actual)
	
	pregunta_actual = Global.preguntas_disponibles.pop_front()
	cargar_textos_en_pantalla()
	
	mensaje_feedback.text = "" 
	$FondoPregunta.show()
	$BotonA.show()
	$BotonB.show()
	$BotonC.show()
	boton_entendido.hide() 
	cartel_progreso.hide()
	
	show()
	get_tree().paused = true 

func cargar_textos_en_pantalla():
	texto_pregunta.text = pregunta_actual["pregunta"]
	respuesta_correcta_texto = pregunta_actual["correcta"]
	
	var opciones = pregunta_actual["falsas"].duplicate()
	opciones.append(respuesta_correcta_texto)
	opciones.shuffle()
	
	opcion_a = opciones[0]
	opcion_b = opciones[1]
	opcion_c = opciones[2]
	
	# AQUÍ ESTÁ EL CAMBIO: Asignamos el texto directamente, sin la letra
	texto_a.text = opcion_a
	texto_b.text = opcion_b
	texto_c.text = opcion_c

func evaluar_respuesta(texto_elegido):
	if texto_elegido == respuesta_correcta_texto:
		victoria()
	else:
		derrota()

func _on_boton_a_pressed(): evaluar_respuesta(opcion_a)
func _on_boton_b_pressed(): evaluar_respuesta(opcion_b)
func _on_boton_c_pressed(): evaluar_respuesta(opcion_c)

func victoria():
	$FondoPregunta.hide()
	$BotonA.hide()
	$BotonB.hide()
	$BotonC.hide()
	boton_entendido.hide()
	mensaje_feedback.hide()
	
	# Desbloqueamos y despausamos al ganar
	Global.bloqueado = false
	get_tree().paused = false
	
	Global.preguntas_respondidas_nivel += 1
	
	cartel_progreso.show()
	texto_progreso.text = "¡Correcto!\nSigue así."
	numero_progreso.text = str(Global.preguntas_respondidas_nivel) + "/3"
	
	await get_tree().create_timer(0.8).timeout
	cartel_progreso.hide()
	hide() 
	
	Global.examen_aprobado.emit()
	
func derrota():
	$BotonA.hide()
	$BotonB.hide()
	$BotonC.hide()
	
	# Si NO estamos en modo seguro, te quitamos vida
	if Global.examen_seguro == false:
		Global.vidas_actuales -= 1
		InterfazVidas.actualizar_vidas()
	
	if Global.vidas_actuales > 0 or Global.examen_seguro == true:
		if Global.examen_seguro == true:
			texto_pregunta.text = "¡INCORRECTO! Pero es un examen de práctica, no pierdes vidas.\n\nPISTA: " + pregunta_actual["feedback"]
		else:
			texto_pregunta.text = "¡INCORRECTO! Perdiste 1 vida.\n\nPISTA: " + pregunta_actual["feedback"]
		boton_entendido.show()
	else:
		texto_pregunta.text = "¡TE QUEDASTE SIN VIDAS!\n\nSegmentation Fault."
		await get_tree().create_timer(3.0, true).timeout
		
		get_tree().paused = false
		Global.bloqueado = false
		hide()
		Global.aplicar_game_over()

func _on_boton_entendido_pressed():
	boton_entendido.hide()
	cargar_textos_en_pantalla()
	$BotonA.show()
	$BotonB.show()
	$BotonC.show()
