extends CanvasLayer

# Usamos onready para buscar el texto del tiempo (Asegúrate de que la ruta sea correcta)
@onready var texto_tiempo = $PanelDerecho/TextoTiempo
@onready var medalla_1 = $PanelDerecho/Medalla1
@onready var medalla_2 = $PanelDerecho/Medalla2
@onready var medalla_3 = $PanelDerecho/Medalla3
@onready var icono_llave = $PanelDerecho/IconoLlave

# NUEVO: Referencia al trofeo
@onready var icono_trofeo = $PanelDerecho/IconoTrofeo 

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
	# Dividimos los segundos totales entre 60.0 (con decimal) y luego lo pasamos a int
	var minutos = int(Global.tiempo_jugado / 60.0)
	
	# El operador % (módulo) saca el sobrante, ahí Godot no se queja
	var segundos = int(Global.tiempo_jugado) % 60
	
	# Le damos formato de reloj digital (ejemplo: 05:09)
	texto_tiempo.text = "Tiempo de viaje: %02d:%02d" % [minutos, segundos]

func actualizar_medallas():
	# Color.WHITE quita el filtro negro y devuelve el color original de la imagen
	
	if Global.insignias >= 1:
		medalla_1.modulate = Color.WHITE
		
	if Global.insignias >= 2:
		medalla_2.modulate = Color.WHITE
		
	if Global.insignias >= 3:
		medalla_3.modulate = Color.WHITE
		
	if Global.llave_casa_roja == true:
		icono_llave.modulate = Color.WHITE # Si elegiste ponerla negra
		
	# NUEVO: Si conseguiste el trofeo, le devolvemos su color original
	if Global.trofeo_pucv_obtenido == true:
		icono_trofeo.modulate = Color.WHITE

# --- SEÑALES DE LOS BOTONES ---
func _on_continuar_pressed():
	reanudar_juego()

func _on_guardar_partida_pressed():
	print("El sistema de guardado está en construcción...")

func _on_salir_del_juego_pressed():
	get_tree().quit()
