extends Node2D

func _ready():
	if Global.has_method("mostrar_vidas") or (typeof(InterfazVidas) != TYPE_NIL):
		InterfazVidas.show()
	
	if has_node("Camera2D"):
		$Camera2D.make_current()
		
	if Global.destino_puerta == "entrar_casa_azul":
		var jugador = get_node_or_null("Jugador")
		var posicion = get_node_or_null("Pos_Entrada") 
		
		if jugador and posicion:
			jugador.global_position = posicion.global_position
			
		Global.destino_puerta = ""
