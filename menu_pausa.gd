extends CanvasLayer

@onready var texto_tiempo = $PanelDerecho/TextoTiempo
@onready var medalla_1 = $PanelDerecho/Medalla1
@onready var medalla_2 = $PanelDerecho/Medalla2
@onready var medalla_3 = $PanelDerecho/Medalla3
@onready var icono_llave = $PanelDerecho/IconoLlave
@onready var icono_trofeo = $PanelDerecho/IconoTrofeo 

# NUEVO: Referencia al trofeo final
@onready var icono_trofeo_final = $PanelDerecho/IconoTrofeoFinal 

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("pausa"):
		if get_tree().paused:
			reanudar_juego()
		else:
			pausar_juego()

func pausar_juego():
	show() 
	get_tree().paused = true 
	actualizar_reloj() 
	actualizar_medallas()

func reanudar_juego():
	hide() 
	get_tree().paused = false 

func actualizar_reloj():
	var minutos = int(Global.tiempo_jugado / 60.0)
	var segundos = int(Global.tiempo_jugado) % 60
	texto_tiempo.text = "Tiempo de viaje: %02d:%02d" % [minutos, segundos]

func actualizar_medallas():
	if Global.insignias >= 1:
		medalla_1.modulate = Color.WHITE
	if Global.insignias >= 2:
		medalla_2.modulate = Color.WHITE
	if Global.insignias >= 3:
		medalla_3.modulate = Color.WHITE
		
	if Global.llave_casa_roja == true:
		icono_llave.modulate = Color.WHITE 
		
	# Trofeo de Silva
	if Global.trofeo_pucv_obtenido == true:
		icono_trofeo.modulate = Color.WHITE
		
	# NUEVO: Trofeo Final del Jefe
	if Global.trofeo_final_obtenido == true:
		icono_trofeo_final.modulate = Color.WHITE

func _on_continuar_pressed():
	reanudar_juego()

func _on_guardar_partida_pressed():
	# Llama a la función que acabamos de crear
	Global.guardar_partida()
	
	# Opcional: Mostrarle al jugador que se guardó cambiando el texto temporalmente
	$PanelDerecho/VBoxContainer/GuardarPartida.text = "¡Partida Guardada!"
	await get_tree().create_timer(2.0).timeout
	$PanelDerecho/VBoxContainer/GuardarPartida.text = "Guardar Partida"

func _on_salir_del_juego_pressed():
	get_tree().quit()
