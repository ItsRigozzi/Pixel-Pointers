extends Area2D

var jugador_cerca = false
@onready var aviso_e = find_child("AvisoFlotante")

func _ready():
	if aviso_e: aviso_e.hide()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if aviso_e: aviso_e.hide()
		
		if nodo_dialogo:
			nodo_dialogo.mostrar_texto("El ascensor sigue en mantenimiento. (Al parecer los desarrolladores no tuvieron tiempo de programar un segundo piso).")

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if aviso_e: aviso_e.show()

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if aviso_e: aviso_e.hide()
		var nodo_dialogo = get_tree().current_scene.get_node_or_null("CapaInterfaz/CajaDialogo")
		if nodo_dialogo: nodo_dialogo.cerrar_dialogo()
