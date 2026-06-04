extends CharacterBody2D

# --- NUEVAS VELOCIDADES ---
var velocidad_normal = 400.0
var velocidad_sprint = 600.0 # Ajusta este número si quieres que corra más o menos rápido

func _ready():
	# --- VIAJES DE LA RUTA K ---
	if Global.destino_puerta == "entra_ruta_k_desde_n2":
		var spawn = get_tree().current_scene.find_child("Pos_Inicio_DesdeN2", true, false)
		if spawn: 
			global_position = spawn.global_position
			
	elif Global.destino_puerta == "entra_n2_desde_ruta_k":
		var spawn = get_tree().current_scene.find_child("Pos_Inicio_DesdeRutaK", true, false)
		if spawn: 
			global_position = spawn.global_position
			
	# --- SALIDA DE LA CASA ROJA ---
	elif Global.destino_puerta == "viene_de_adentro_casa_roja":
		var spawn = get_tree().current_scene.find_child("Pos_Inicio_CasaRoja", true, false)
		if spawn: 
			global_position = spawn.global_position
			
	elif Global.destino_puerta == "entra_n3_desde_ruta_k":
		var spawn = get_tree().current_scene.find_child("Pos_Inicio_DesdeRutaK", true, false)
		if spawn: 
			global_position = spawn.global_position
			
	elif Global.destino_puerta == "entra_ruta_k_desde_n3":
		var spawn = get_tree().current_scene.find_child("Pos_Inicio_DesdeN3", true, false)
		if spawn: 
			global_position = spawn.global_position
			
	elif Global.destino_puerta == "sale_edificio1_n3":
		var spawn = get_tree().current_scene.find_child("Pos_Inicio_Edificio1", true, false)
		if spawn: 
			global_position = spawn.global_position
		
	elif Global.destino_puerta == "entra_edificio1_n3":
		var spawn = get_tree().current_scene.find_child("Pos_Inicio_Puerta1", true, false)
		if spawn: 
			global_position = spawn.global_position
		
	elif Global.destino_puerta == "entra_edificio2_n3":
		var spawn = get_tree().current_scene.find_child("Pos_Inicio_Puerta2", true, false)
		if spawn: global_position = spawn.global_position
		
	elif Global.destino_puerta == "sale_edificio2_n3":
		var spawn = get_tree().current_scene.find_child("Pos_Inicio_Edificio2", true, false)
		if spawn: global_position = spawn.global_position
	
func _physics_process(_delta):
	# --- BOTÓN DE PÁNICO ---
	if Input.is_action_just_pressed("ui_cancel"):
		if Global.bloqueado == true:
			Global.desbloquear_jugador()
	# -----------------------

	var direction = Vector2.ZERO
	
	# Solo calculamos dirección si no está bloqueado
	if Global.bloqueado == false:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# --- EL TRUCO DEL SPRINT ---
	var velocidad_actual = velocidad_normal
	if Input.is_physical_key_pressed(KEY_SHIFT):
		velocidad_actual = velocidad_sprint
	
	# Aplicamos la velocidad calculada
	velocity = direction * velocidad_actual
	
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			$AnimationPlayer.play("caminar_derecha" if direction.x > 0 else "caminar_izquierda")
		else:
			$AnimationPlayer.play("caminar_abajo" if direction.y > 0 else "caminar_arriba")
	else:
		$AnimationPlayer.stop()
		
	move_and_slide()
