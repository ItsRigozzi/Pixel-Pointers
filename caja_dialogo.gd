extends Control

@onready var texto_label = $NinePatchRect/RichTextLabel

func _ready():
	hide() 

func mostrar_texto(nuevo_texto: String):
	texto_label.text = nuevo_texto
	show()

# ESTA ES LA ÚNICA QUE DEBES USAR
func cerrar_dialogo():
	Global.bloqueado = false # Liberamos el candado
	hide()                   # Ocultamos la caja
