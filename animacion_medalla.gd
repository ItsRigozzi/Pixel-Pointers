extends CanvasLayer

@onready var fondo = $Fondo
@onready var icono = $IconoMedalla
@onready var texto = $Texto

func _ready():
	hide()

func mostrar_recompensa(textura_medalla, mensaje = "¡Has obtenido una Insignia!"):
	icono.texture = textura_medalla
	texto.text = mensaje 
	
	get_tree().paused = true
	show()
	
	fondo.modulate.a = 0.0
	icono.modulate.a = 0.0
	texto.modulate.a = 0.0
	
	icono.scale = Vector2(0.5, 0.5)
	icono.pivot_offset = icono.size / 2
	
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	tween.set_parallel(true)
	tween.tween_property(fondo, "modulate:a", 1.0, 0.5)
	tween.tween_property(texto, "modulate:a", 1.0, 0.5)
	tween.tween_property(icono, "modulate:a", 1.0, 0.5)
	tween.tween_property(icono, "scale", Vector2(1.2, 1.2), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	tween.set_parallel(false) 
	tween.tween_interval(3.0)
	
	tween.set_parallel(true)
	tween.tween_property(fondo, "modulate:a", 0.0, 0.5)
	tween.tween_property(texto, "modulate:a", 0.0, 0.5)
	tween.tween_property(icono, "modulate:a", 0.0, 0.5)
	
	tween.set_parallel(false)
	tween.tween_callback(finalizar_animacion)

func finalizar_animacion():
	hide()
	get_tree().paused = false
