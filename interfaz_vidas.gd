extends CanvasLayer

# Ahora sí busca el nombre exacto de tu nodo
@onready var contenedor = $ContenedorCorazones
var corazon_lleno = preload("res://corazon_rojo.tres")
var corazon_vacio = preload("res://corazon_gris.tres")

func _ready():
	actualizar_vidas()

func actualizar_vidas():
	# 1. Limpiamos todos los corazones viejos de la pantalla
	for hijo in contenedor.get_children():
		hijo.queue_free()
		
	# 2. Dibujamos los corazones desde cero basados en la salud actual y máxima
	for i in range(Global.vidas_maximas):
		var nuevo_corazon = TextureRect.new()
		
		# Si 'i' es menor que las vidas actuales, el corazón está lleno. Si no, está vacío.
		if i < Global.vidas_actuales:
			nuevo_corazon.texture = corazon_lleno
		else:
			nuevo_corazon.texture = corazon_vacio
			
		contenedor.add_child(nuevo_corazon)
