extends Area2D

var jugador_cerca = false
@onready var aviso_e = find_child("AvisoFlotante")

func _ready():
	if aviso_e: aviso_e.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		dar_recompensa()

func dar_recompensa():
	var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
	
	if Global.recompensa_casa_roja_reclamada == false:
		Global.vidas_maximas += 1
		Global.recompensa_casa_roja_reclamada = true
		
		if InterfazVidas:
			InterfazVidas.actualizar_vidas()
		
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("¡Has leído un manual avanzado! Tu salud máxima ha aumentado a " + str(Global.vidas_maximas) + ", pero necesitas encontrar comida para llenarlo.")
	else:
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("Ya leíste este libro de principio a fin.")

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if aviso_e: aviso_e.show()

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if aviso_e: aviso_e.hide()
		
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo:
			nodo_dialogo.cerrar_dialogo()
