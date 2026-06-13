extends Control

@onready var boton_continuar = $BotonContinuar 
@onready var panel_como_jugar = $PanelComoJugar
@onready var panel_config = $PanelConfig

func _ready():
	if InterfazVidas:
		InterfazVidas.hide()
	
	Global.inicializar_log()
	
	panel_como_jugar.hide()
	panel_config.hide()
	
	aplicar_controles(Global.controles)
	
	if FileAccess.file_exists(Global.RUTA_GUARDADO):
		boton_continuar.show()
	else:
		if boton_continuar:
			boton_continuar.hide()

func _on_boton_iniciar_pressed():
	get_tree().change_scene_to_file("res://intro_narrativa.tscn")

func _on_boton_continuar_pressed():
	var carga_exitosa = Global.cargar_partida()
	
	if carga_exitosa:
		aplicar_controles(Global.controles) 
		
		if Global.insignias == 0:
			get_tree().change_scene_to_file("res://pueblo_principal.tscn")
		elif Global.insignias == 1:
			get_tree().change_scene_to_file("res://mapa_nivel_2.tscn")
		else:
			get_tree().change_scene_to_file("res://mapa_nivel_3.tscn")

func _on_boton_salir_pressed():
	var ruta_absoluta = ProjectSettings.globalize_path("user://")
	
	OS.shell_open(ruta_absoluta)
	
	await get_tree().create_timer(0.5).timeout
	
	get_tree().quit()

func _on_boton_como_jugar_pressed():
	panel_como_jugar.show()

func _on_boton_config_pressed():
	panel_config.show()

func _on_boton_volver_cj_pressed():
	panel_como_jugar.hide()

func _on_boton_volver_config_pressed():
	panel_config.hide()

func _on_boton_wasd_pressed():
	Global.controles = "wasd"
	aplicar_controles("wasd")
	panel_config.hide()

func _on_boton_flechas_pressed():
	Global.controles = "flechas"
	aplicar_controles("flechas")
	panel_config.hide()

func aplicar_controles(modo):
	var arriba = InputEventKey.new()
	var abajo = InputEventKey.new()
	var izq = InputEventKey.new()
	var der = InputEventKey.new()
	
	if modo == "wasd":
		arriba.physical_keycode = KEY_W
		abajo.physical_keycode = KEY_S
		izq.physical_keycode = KEY_A
		der.physical_keycode = KEY_D
	else:
		arriba.physical_keycode = KEY_UP
		abajo.physical_keycode = KEY_DOWN
		izq.physical_keycode = KEY_LEFT
		der.physical_keycode = KEY_RIGHT
	
	InputMap.action_erase_events("ui_up")
	InputMap.action_add_event("ui_up", arriba)
	
	InputMap.action_erase_events("ui_down")
	InputMap.action_add_event("ui_down", abajo)
	
	InputMap.action_erase_events("ui_left")
	InputMap.action_add_event("ui_left", izq)
	
	InputMap.action_erase_events("ui_right")
	InputMap.action_add_event("ui_right", der)
	
	print("Controles actualizados a: ", modo)
