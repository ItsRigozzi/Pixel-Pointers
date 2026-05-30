extends Node

var cofre_herreria_abierto: bool = false
var destino_puerta = ""
var llave_casa_roja = false
var rubia_dio_fruta_nivel = false # Nuevo: Prevención de abuso
var nivel_1_aprobado = false
@warning_ignore("unused_signal")
signal examen_aprobado
# --- VARIABLES DE MAPA ---
var punto_aparicion = ""
var posicion_jugador = Vector2.ZERO 
var direccion_jugador = "abajo"     

# --- ESTADÍSTICAS DEL JUGADOR ---
var vidas_maximas = 3
var vidas_actuales = 3
var insignias = 0
var nivel_actual = 1 # Para saber a dónde respawnear y qué preguntas usar
var preguntas_respondidas_nivel = 0 # Para saber si ya llegó a 3/3

# --- VARIABLES PARA MEZCLAR PREGUNTAS ---
var preguntas_disponibles = [] 

# --- BANCO DE PREGUNTAS (NIVEL 1) ---
var banco_nivel_1 = [
	{
		"pregunta": "¿Qué almacena exactamente una variable de tipo puntero en C?",
		"correcta": "La dirección de memoria de otra variable.",
		"falsas": ["El valor de un dato entero o decimal.", "La cantidad de memoria RAM del programa."],
		"feedback": "Recuerda que un puntero 'apunta' a la ubicación física de un dato, no al dato en sí."
	},
	{
		"pregunta": "¿Qué símbolo se usa para obtener la dirección de memoria?",
		"correcta": "El operador de dirección (&).",
		"falsas": ["El operador de indirección (*).", "El operador de porcentaje (%)."],
		"feedback": "Piensa en el símbolo que usas dentro de un scanf() tradicional en C."
	},
	{
		"pregunta": "¿Qué representa asignar NULL a un puntero?",
		"correcta": "Que no apunta a ninguna dirección válida.",
		"falsas": ["Que su valor numérico es cero.", "Que libera automáticamente la memoria."],
		"feedback": "NULL significa nulo o vacío, es decir, el puntero está inicializado pero no apunta a nada real."
	},
	{
		"pregunta": "¿Qué tipo de dato almacena un puntero doble (**)?",
		"correcta": "La dirección de memoria de otro puntero.",
		"falsas": ["El doble de memoria que un puntero normal.", "Una matriz bidimensional estática."],
		"feedback": "Así como un puntero normal apunta a una variable, un puntero doble apunta a un puntero normal."
	}
]

# --- NUEVO: BANCO DE PREGUNTAS (NIVEL 2) ---
var banco_nivel_2 = [
	{
		"pregunta": "¿Qué función se utiliza para asignar memoria dinámica en C?",
		"correcta": "malloc()",
		"falsas": ["free()", "alloc_mem()"],
		"feedback": "Busca la función cuyo nombre proviene de 'Memory Allocation'."
	},
	{
		"pregunta": "¿Qué sucede si no liberas la memoria dinámica asignada con malloc?",
		"correcta": "Se produce una fuga de memoria (memory leak).",
		"falsas": ["El compilador borra el código automáticamente.", "El programa corre más rápido."],
		"feedback": "La memoria dinámica no se limpia sola, se queda bloqueada causando una 'fuga'."
	},
	{
		"pregunta": "Después de usar memoria dinámica, ¿con qué función debes liberarla?",
		"correcta": "free()",
		"falsas": ["delete()", "clear()"],
		"feedback": "Piensa en la palabra en inglés para 'liberar'."
	},
	{
		"pregunta": "Si un puntero 'p' es un arreglo dinámico, ¿cómo accedes a su primer elemento?",
		"correcta": "p[0] o *p",
		"falsas": ["&p", "p->0"],
		"feedback": "Los punteros dinámicos se pueden tratar con la misma sintaxis que los arreglos normales."
	}
]

func preparar_preguntas_nivel(nivel):
	randomize() 
	preguntas_disponibles.clear()
	
	# NUEVO: Aquí el juego decide qué banco usar según en qué nivel estés
	if nivel == 1:
		preguntas_disponibles = banco_nivel_1.duplicate()
	elif nivel == 2:
		preguntas_disponibles = banco_nivel_2.duplicate()
	
	preguntas_disponibles.shuffle() 
	preguntas_respondidas_nivel = 0

func aplicar_game_over():
	vidas_actuales = vidas_maximas
	InterfazVidas.actualizar_vidas()
	preguntas_respondidas_nivel = 0
	
	preparar_preguntas_nivel(nivel_actual)
	
	if nivel_actual == 1:
		get_tree().change_scene_to_file("res://pueblo_principal.tscn")
	elif nivel_actual == 2:
		# NUEVO: Si mueres en el Nivel 2, reapareces en el Nivel 2
		get_tree().change_scene_to_file("res://mapa_nivel_2.tscn")

func curar_vida(cantidad):
	vidas_actuales += cantidad
	if vidas_actuales > vidas_maximas:
		vidas_actuales = vidas_maximas
	InterfazVidas.actualizar_vidas()
