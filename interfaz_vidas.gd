extends CanvasLayer

@onready var contenedor = $ContenedorCorazones

# Cargamos tus imágenes para usarlas en el código
var corazon_rojo = preload("res://corazon_rojo.tres")
var corazon_gris = preload("res://corazon_gris.tres")

func _ready():
	actualizar_vidas()

func actualizar_vidas():
	# Agarramos los 5 corazones que creaste en una lista
	var lista_corazones = contenedor.get_children()
	
	for i in range(lista_corazones.size()):
		# 1. Si el corazón está dentro del máximo permitido (ej: 5), lo mostramos
		if i < Global.vidas_maximas:
			lista_corazones[i].show()
			
			# 2. Si el número de corazón es menor a tus vidas actuales, lo pintamos ROJO
			if i < Global.vidas_actuales:
				lista_corazones[i].texture = corazon_rojo
			# Si no tienes esa vida, lo pintamos GRIS (corazón vacío)
			else:
				lista_corazones[i].texture = corazon_gris
				
		# 3. Si por alguna razón sobran corazones (ej: bajaste el máximo a 3), los ocultamos
		else:
			lista_corazones[i].hide()
