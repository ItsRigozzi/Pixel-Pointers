extends Control

@onready var texto_label = $NinePatchRect/RichTextLabel

func _ready():
	hide() 

func mostrar_texto(nuevo_texto: String):
	texto_label.text = nuevo_texto
	show()
