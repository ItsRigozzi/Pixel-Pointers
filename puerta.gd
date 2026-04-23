extends Area2D

var jugador_cerca = false

func _ready():
	# Esto se ejecuta UN segundo después de darle a Play
	$AvisoFlotante.hide()
	
func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		var escena_actual = get_tree().current_scene.name
		
		# Solución 2: Verificamos los nombres de escena (asegúrate de que coincidan)
		if escena_actual == "pueblo_principal" or escena_actual == "pueblo_base":
			get_tree().change_scene_to_file("res://casa_limpia.tscn")
		else:
			get_tree().change_scene_to_file("res://pueblo_principal.tscn")

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		$AvisoFlotante.show()

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		$AvisoFlotante.hide()
