extends CanvasLayer

@onready var contenedor = $ContenedorCorazones
var corazon_lleno = preload("res://corazon_rojo.tres")
var corazon_vacio = preload("res://corazon_gris.tres")

func _ready():
	actualizar_vidas()

func actualizar_vidas():
	for hijo in contenedor.get_children():
		hijo.queue_free()
		
	for i in range(Global.vidas_maximas):
		var nuevo_corazon = TextureRect.new()
		
		if i < Global.vidas_actuales:
			nuevo_corazon.texture = corazon_lleno
		else:
			nuevo_corazon.texture = corazon_vacio
			
		contenedor.add_child(nuevo_corazon)
