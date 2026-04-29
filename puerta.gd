extends Area2D

@export_file("*.tscn") var escena_destino: String 
# NUEVO: Para escribir en el Inspector el punto exacto
@export var nombre_punto_destino: String = "" 

var jugador_cerca = false

func _ready():
	$AvisoFlotante.hide()
	
func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		if escena_destino != "":
			# NUEVO: Le avisamos al Global antes de viajar
			Global.punto_aparicion = nombre_punto_destino
			get_tree().change_scene_to_file(escena_destino)
		else:
			print("¡Falta poner la escena destino en el Inspector!")

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		$AvisoFlotante.show()

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		$AvisoFlotante.hide()
