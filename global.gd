extends Node

var controles = "wasd" # Por defecto empezarán con WASD
var errores_nivel_1 = 0
var errores_nivel_2 = 0
var errores_nivel_3 = 0
var trofeo_final_obtenido = false
var npc_traje_n3_respondido = false
var silva_ruta_k_respondida = false # Recuerda si ya vencimos a Silva (ya sea por cura o trofeo)
var npc_nivel3_respondido = false
var examen_seguro = false # Nuevo: para que la pregunta no quite vidas
var trofeo_pucv_obtenido = false # Nuevo: para registrar tu premio perfecto
var hitos_nivel_2_completados = 0 # Esta SÍ será permanente
var bloqueado = false # Nuevo candado para detener al jugador
var recompensa_casa_roja_reclamada = false
var tiempo_jugado: float = 0.0
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

# ==========================================
# NIVEL 1: Conceptos Básicos y Operadores
# ==========================================
var preguntas_nivel_1 = [
	{
		"pregunta": "¿Qué guarda exactamente una variable de tipo puntero en C?",
		"correcta": "Una dirección de memoria.",
		"falsas": ["Un número decimal.", "La memoria RAM total."],
		"feedback": "Los punteros actúan como mapas; guardan las coordenadas de dónde está el dato."
	},
	{
		"pregunta": "¿Qué símbolo se usa para obtener la dirección de una variable?",
		"correcta": "El ampersand (&).",
		"falsas": ["El asterisco (*).", "El porcentaje (%)."],
		"feedback": "El ampersand (&) se lee como 'la dirección de'."
	},
	{
		"pregunta": "¿Qué hace el operador asterisco (*) junto a un puntero?",
		"correcta": "Accede al valor guardado en esa dirección.",
		"falsas": ["Multiplica la dirección por cero.", "Borra la variable original."],
		"feedback": "Se conoce como desreferenciación, te permite ver o cambiar el dato real."
	},
	{
		"pregunta": "¿Qué significa asignarle NULL a un puntero?",
		"correcta": "Que no apunta a ninguna parte.",
		"falsas": ["Que su valor numérico es cero.", "Que borra la memoria."],
		"feedback": "NULL es la forma segura de decir 'este puntero está vacío por ahora'."
	},
	{
		"pregunta": "¿Qué es un 'puntero no inicializado'?",
		"correcta": "Un puntero sin dirección asignada.",
		"falsas": ["Un puntero que cambia de valor.", "Un puntero exclusivo de texto."],
		"feedback": "Es peligroso, ya que apuntará a una zona de memoria aleatoria (basura)."
	},
	{
		"pregunta": "¿Cuánto tamaño ocupa un puntero en una arquitectura de 64 bits?",
		"correcta": "8 bytes.",
		"falsas": ["4 bytes.", "Depende del dato."],
		"feedback": "Sin importar si apunta a un int o a un double, la coordenada siempre ocupa 8 bytes."
	},
	{
		"pregunta": "¿Cómo se declara correctamente un puntero a un número entero?",
		"correcta": "int *p;",
		"falsas": ["int p*;", "pointer p;"],
		"feedback": "El tipo de dato seguido del asterisco define la declaración."
	},
	{
		"pregunta": "Si tienes el siguiente código:\nint x = 5;\n\n¿Qué obtienes con la expresión '&x'?",
		"correcta": "Un puntero a entero.",
		"falsas": ["Un entero normal.", "Un error de código."],
		"feedback": "Al extraer la dirección de un int, obtienes automáticamente un puntero a int."
	},
	{
		"pregunta": "¿Se le pueden sumar o restar números a un puntero?",
		"correcta": "Sí, es la aritmética de punteros.",
		"falsas": ["No, son constantes.", "Solo en C++."],
		"feedback": "Sirve para avanzar o retroceder a través de arreglos en la memoria."
	},
	{
		"pregunta": "¿Qué significa el tipo de dato 'void *'?",
		"correcta": "Un puntero genérico sin tipo.",
		"falsas": ["Un puntero que se autodestruye.", "Un error de compilación."],
		"feedback": "Es muy útil, pero debe ser convertido (casteado) antes de leer su valor."
	},
	{
		"pregunta": "¿En qué formato visual se suele mostrar una dirección de memoria?",
		"correcta": "En formato hexadecimal.",
		"falsas": ["En código binario.", "En números decimales."],
		"feedback": "Se expresan en base 16, por ejemplo: 0x7ffd."
	},
	{
		"pregunta": "Al escribir la siguiente línea:\nint *p1, p2;\n\n¿Qué variables se crean?",
		"correcta": "p1 es puntero, p2 es entero normal.",
		"falsas": ["Ambos son punteros.", "Da error de sintaxis."],
		"feedback": "El asterisco solo afecta a la variable que tiene pegada a la derecha."
	},
	{
		"pregunta": "¿Qué ocurre si comparamos dos punteros así:\n\np1 == p2",
		"correcta": "Revisa si apuntan a la misma dirección.",
		"falsas": ["Suma los valores de ambos.", "Revisa si el dato guardado es igual."],
		"feedback": "Compara las coordenadas del mapa, no el tesoro que hay en ellas."
	},
	{
		"pregunta": "Si 'p' vale NULL, ¿qué pasa al intentar hacer esto:\n\n*p = 10;",
		"correcta": "El programa colapsa.",
		"falsas": ["Se crea la variable sola.", "El programa ignora la línea."],
		"feedback": "No puedes guardar un dato en 'ninguna parte'. Esto causa un Segmentation Fault."
	},
	{
		"pregunta": "¿Puede un puntero guardar la dirección de otro puntero?",
		"correcta": "Sí, se llama puntero doble.",
		"falsas": ["No, solo variables normales.", "Solo en sistemas antiguos."],
		"feedback": "Su sintaxis utiliza múltiples asteriscos, como int **p;"
	}
]

# ==========================================
# NIVEL 2: Punteros Dobles y Estructuras
# ==========================================
var preguntas_nivel_2 = [
	{
		"pregunta": "Completa la sintaxis:\n\nint num = 40;\nint *ptr = &num;\n____ pptr = &ptr;",
		"correcta": "int **",
		"falsas": ["int *", "int &&"],
		"feedback": "Un puntero que guarda la dirección de otro puntero lleva dos asteriscos."
	},
	{
		"pregunta": "¿Qué operador usas en el puntero doble 'pptr' para cambiar 'num' a 50?",
		"correcta": "**pptr = 50;",
		"falsas": ["*pptr = 50;", "pptr = 50;"],
		"feedback": "El primer * te lleva al puntero intermedio, el segundo * te lleva al valor final."
	},
	{
		"pregunta": "Tienes 'int **p2' que apunta a un 'int *p1'.\n¿Qué obtienes al hacer '*p2'?",
		"correcta": "La dirección de p1.",
		"falsas": ["El valor final del entero.", "Un error grave."],
		"feedback": "Al usar un solo asterisco, te quedas a medio camino en el puntero intermedio."
	},
	{
		"pregunta": "Tienes un arreglo de punteros y un doble puntero 'ptr'. ¿Cómo llegas al dato final?",
		"correcta": "*(*ptr)",
		"falsas": ["*ptr", "ptr[0]"],
		"feedback": "Como es un arreglo de punteros, necesitas doble desreferenciación para llegar al número."
	},
	{
		"pregunta": "Si ejecutas el siguiente código:\n\nint *ptr = datos;\nptr++;\n\n¿Qué sucede?",
		"correcta": "Avanza a la siguiente posición del arreglo.",
		"falsas": ["Suma 1 al primer número.", "El programa colapsa."],
		"feedback": "El operador ++ mueve el puntero al siguiente bloque de memoria válido."
	},
	{
		"pregunta": "Si 'ptr' apunta a un int (4 bytes) y haces 'ptr + 2', ¿cuánto avanza en RAM?",
		"correcta": "8 bytes.",
		"falsas": ["2 bytes.", "4 bytes."],
		"feedback": "Avanza '2 espacios del tamaño del dato'. 2 espacios de 4 bytes = 8 bytes."
	},
	{
		"pregunta": "En la siguiente declaración:\n\nchar *cadena = \"Hola\";\n\n¿A qué apunta exactamente '*cadena'?",
		"correcta": "Al carácter 'H'.",
		"falsas": ["Al carácter 'a'.", "A la palabra entera."],
		"feedback": "Los strings son arreglos, el puntero siempre apunta a la primera letra."
	},
	{
		"pregunta": "Si 'p' apunta a un arreglo 'arr', ¿qué código equivale a 'arr[3]'?",
		"correcta": "*(p + 3)",
		"falsas": ["*p + 3", "p[4]"],
		"feedback": "Los corchetes son solo un atajo visual para sumar direcciones y desreferenciar."
	},
	{
		"pregunta": "Tienes un puntero 'p' a una estructura. ¿Cómo accedes a su variable 'valor'?",
		"correcta": "p->valor",
		"falsas": ["p.valor", "p*valor"],
		"feedback": "El operador flecha (->) es el atajo para acceder a atributos a través de un puntero."
	},
	{
		"pregunta": "¿Qué diferencia hay entre usar:\n(*p)++\ncontra usar:\n*p++",
		"correcta": "Uno suma al dato, el otro mueve el puntero.",
		"falsas": ["Hacen exactamente lo mismo.", "Uno da error de sintaxis."],
		"feedback": "Los paréntesis obligan a sumar primero el número guardado en la memoria."
	},
	{
		"pregunta": "¿Es válido restar dos punteros del mismo tipo?\n(Ejemplo: p2 - p1)",
		"correcta": "Sí, da la distancia entre ellos.",
		"falsas": ["No, no está permitido.", "Sí, suma sus valores."],
		"feedback": "Es muy útil para saber cuántos elementos hay entre dos puntos de un arreglo."
	},
	{
		"pregunta": "¿Cómo pasas un puntero a una función para cambiar hacia dónde apunta?",
		"correcta": "Pasando un puntero doble (**).",
		"falsas": ["Pasando un puntero normal (*).", "Usando la palabra 'ref'."],
		"feedback": "Para cambiar un puntero desde otra función, necesitas la dirección de ese puntero."
	},
	{
		"pregunta": "¿Qué significa la siguiente declaración en C?\n\nconst int *p;",
		"correcta": "El puntero se mueve, pero el dato no cambia.",
		"falsas": ["El puntero es fijo, el dato cambia.", "Ninguno puede cambiar."],
		"feedback": "Se lee como 'un puntero a un entero constante'."
	},
	{
		"pregunta": "¿Qué significa la siguiente declaración en C?\n\nint * const p;",
		"correcta": "El puntero es fijo, pero el dato sí cambia.",
		"falsas": ["El dato es fijo.", "Ninguno puede cambiar."],
		"feedback": "Se lee como 'un puntero constante a un entero'."
	},
	{
		"pregunta": "¿Para qué sirve un 'puntero a función'?",
		"correcta": "Guarda la dirección donde vive el código.",
		"falsas": ["Una función que retorna punteros.", "Una función para crear memoria."],
		"feedback": "Permite usar funciones como si fueran variables (callbacks)."
	}
]

# ==========================================
# NIVEL 3: Debugging y Lógica Compleja
# ==========================================
var preguntas_nivel_3 = [
	{
		"pregunta": "Identifica el error que causará un Segmentation Fault inmediato:",
		"correcta": "int *p; *p = 10;",
		"falsas": ["int *p = NULL;", "int x = 5; int *p = &x;"],
		"feedback": "Este es un 'Wild Pointer'. Intentas guardar un 10 en una memoria que no has reservado."
	},
	{
		"pregunta": "Analiza el siguiente código:\n\nint arr[3] = {1,2,3};\nint *p = arr;\np += 5;\n*p = 10;\n\n¿Qué error ocurre?",
		"correcta": "Desbordamiento de búfer (Buffer Overflow).",
		"falsas": ["Error de sintaxis.", "El arreglo no puede asignarse."],
		"feedback": "Estás invadiendo memoria fuera de los límites del arreglo."
	},
	{
		"pregunta": "Se requiere liberar memoria dinámica. ¿Qué función falta?\n\nint *p = malloc(sizeof(int));\n...\n_____ (p);",
		"correcta": "free",
		"falsas": ["delete", "clear"],
		"feedback": "En C puro, todo lo reservado con malloc/calloc debe ser devuelto con free."
	},
	{
		"pregunta": "¿Cuál es el error crítico de este código?\n\nint* f() {\n    int local = 10;\n    return &local;\n}",
		"correcta": "Retorna un Dangling Pointer.",
		"falsas": ["Falta inicializar con NULL.", "El retorno debería ser *local."],
		"feedback": "Las variables locales mueren cuando termina la función."
	},
	{
		"pregunta": "¿Qué problema causa este código?\n\nint *p = malloc(sizeof(int));\nfree(p);\n*p = 5;",
		"correcta": "Un error 'Use-After-Free'.",
		"falsas": ["Un error al compilar.", "El valor se vuelve NULL."],
		"feedback": "Usar memoria después de liberarla es una de las vulnerabilidades más graves en C."
	},
	{
		"pregunta": "¿Qué ocurre si olvidas llamar a free() sobre memoria que ya no vas a usar?",
		"correcta": "Se genera un Memory Leak.",
		"falsas": ["Se libera sola al final.", "Da un error de GCC."],
		"feedback": "El programa consumirá RAM de forma infinita."
	},
	{
		"pregunta": "¿Cuál es la principal diferencia entre malloc y calloc?",
		"correcta": "calloc inicializa la memoria con ceros.",
		"falsas": ["malloc es para int, calloc para floats.", "calloc libera antes de reservar."],
		"feedback": "calloc asegura que no tengas basura en la memoria al iniciar."
	},
	{
		"pregunta": "Necesitas expandir el tamaño de memoria ya reservada. ¿Qué función usas?",
		"correcta": "realloc",
		"falsas": ["malloc_extend", "new_size"],
		"feedback": "realloc intenta expandir el bloque actual o busca uno nuevo."
	},
	{
		"pregunta": "¿Qué retorna malloc si no hay más memoria RAM disponible?",
		"correcta": "NULL",
		"falsas": ["Un número negativo (-1).", "Crashea el sistema."],
		"feedback": "Por eso siempre debes verificar 'if (p == NULL)' después del malloc."
	},
	{
		"pregunta": "¿Qué sucede si haces un 'Double Free'?\n(Llamar a free dos veces sobre un puntero)",
		"correcta": "Corrupción del Heap y caída inminente.",
		"falsas": ["La segunda llamada es ignorada.", "Borra la variable siguiente."],
		"feedback": "El gestor de memoria colapsa al intentar liberar algo que ya está libre."
	},
	{
		"pregunta": "Tienes el siguiente código:\n\nchar *p = \"Hola\";\np[0] = 'h';\n\n¿Por qué ocurre un Segmentation Fault?",
		"correcta": "Modificas memoria de solo lectura.",
		"falsas": ["Los strings no permiten minúsculas.", "Faltó desreferenciar con asterisco."],
		"feedback": "Las cadenas literales se guardan en un segmento protegido."
	},
	{
		"pregunta": "¿Qué herramienta de Linux detecta Memory Leaks en C?",
		"correcta": "Valgrind",
		"falsas": ["GCC", "GDB"],
		"feedback": "Valgrind intercepta y rastrea todas tus llamadas a malloc y free."
	},
	{
		"pregunta": "¿Qué significa el error 'Stack Overflow' en tiempo de ejecución?",
		"correcta": "Agotamiento de la pila de memoria.",
		"falsas": ["Falta de espacio en disco.", "Demasiados datos en scanf."],
		"feedback": "Usualmente causado por recursión infinita o arreglos locales muy grandes."
	},
	{
		"pregunta": "¿Por qué es buena práctica hacer 'p = NULL;' después de 'free(p);'?",
		"correcta": "Para evitar un Dangling Pointer accidental.",
		"falsas": ["Para devolver la memoria más rápido.", "Porque lo exige el estándar C."],
		"feedback": "Si luego intentas usar 'p' por error, el programa crasheará seguro en lugar de corromper datos en silencio."
	},
	{
		"pregunta": "¿En qué región de la memoria trabajan las funciones malloc/free?",
		"correcta": "El Heap (Montículo).",
		"falsas": ["El Stack (Pila).", "El Text Segment."],
		"feedback": "El Heap es la memoria dinámica donde tú gestionas la vida y muerte de los datos."
	}
]

func desbloquear_jugador():
	bloqueado = false
	print("Desbloqueo forzado aplicado.")
	
func preparar_preguntas_nivel(nivel):
	randomize() 
	preguntas_disponibles.clear()
	
	if nivel == 1:
		preguntas_disponibles = preguntas_nivel_1.duplicate()
	elif nivel == 2:
		preguntas_disponibles = preguntas_nivel_2.duplicate()
	elif nivel == 3:
		preguntas_disponibles = preguntas_nivel_3.duplicate()
	
	preguntas_disponibles.shuffle() 
	preguntas_respondidas_nivel = 0

func aplicar_game_over():
	# 1. Curamos al jugador y reiniciamos el contador de ese nivel
	vidas_actuales = vidas_maximas
	InterfazVidas.actualizar_vidas()
	preguntas_respondidas_nivel = 0
	
	# 2. Barajamos las preguntas del nivel en el que murió
	preparar_preguntas_nivel(nivel_actual)
	
	# ==========================================
	# 3. RESET DE MEMORIAS (SISTEMA DE CHECKPOINTS)
	# ==========================================
	if nivel_actual == 1:
		# En el Nivel 1 no hay memorias permanentes de NPCs que limpiar por ahora
		get_tree().change_scene_to_file("res://pueblo_principal.tscn")
		
	elif nivel_actual == 2:
		# Si muere en el Nivel 2, Silva olvida que le respondiste
		silva_ruta_k_respondida = false
		get_tree().change_scene_to_file("res://mapa_nivel_2.tscn")
		
	elif nivel_actual == 3:
		# Si muere en el Nivel 3, Mellado y el chico del traje olvidan que les respondiste
		npc_nivel3_respondido = false
		npc_traje_n3_respondido = false
		get_tree().change_scene_to_file("res://mapa_nivel_3.tscn")

func curar_vida(cantidad):
	# Si el jugador ya está al máximo de vida, le damos un contenedor extra
	if vidas_actuales == vidas_maximas:
		vidas_maximas += cantidad
		vidas_actuales = vidas_maximas
	else:
		# Si está herido, solo lo curamos hasta el máximo actual
		vidas_actuales += cantidad
		if vidas_actuales > vidas_maximas:
			vidas_actuales = vidas_maximas
			
	InterfazVidas.actualizar_vidas()
# --- SISTEMA DE GUARDADO ---
const RUTA_GUARDADO = "user://partida.save"

func guardar_partida():
	# Diccionario ACTUALIZADO con todos los eventos del juego
	var datos = {
		"insignias": insignias,
		"tiempo_jugado": tiempo_jugado,
		"llave_casa_roja": llave_casa_roja,
		"trofeo_pucv_obtenido": trofeo_pucv_obtenido,
		"trofeo_final_obtenido": trofeo_final_obtenido,
		"nivel_1_aprobado": nivel_1_aprobado,
		"errores_nivel_1": errores_nivel_1,
		"errores_nivel_2": errores_nivel_2,
		"errores_nivel_3": errores_nivel_3,
		"preguntas_respondidas_nivel": preguntas_respondidas_nivel,
		"npc_nivel3_respondido": npc_nivel3_respondido,
		"npc_traje_n3_respondido": npc_traje_n3_respondido,
		
		# --- EVENTOS Y OBJETOS NUEVOS AÑADIDOS ---
		"silva_ruta_k_respondida": silva_ruta_k_respondida,
		"hitos_nivel_2_completados": hitos_nivel_2_completados,
		"recompensa_casa_roja_reclamada": recompensa_casa_roja_reclamada,
		"cofre_herreria_abierto": cofre_herreria_abierto,
		"rubia_dio_fruta_nivel": rubia_dio_fruta_nivel,
		"vidas_maximas": vidas_maximas,
		"vidas_actuales": vidas_actuales,
		"nivel_actual": nivel_actual,
		"controles": controles
	}
	
	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.WRITE)
	archivo.store_string(JSON.stringify(datos))
	archivo.close()
	print("Partida guardada con éxito en: ", RUTA_GUARDADO)

func cargar_partida():
	if FileAccess.file_exists(RUTA_GUARDADO):
		var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.READ)
		var contenido = archivo.get_as_text()
		archivo.close()
		
		var datos = JSON.parse_string(contenido)
		if datos:
			insignias = datos.get("insignias", 0)
			tiempo_jugado = datos.get("tiempo_jugado", 0.0)
			llave_casa_roja = datos.get("llave_casa_roja", false)
			trofeo_pucv_obtenido = datos.get("trofeo_pucv_obtenido", false)
			trofeo_final_obtenido = datos.get("trofeo_final_obtenido", false)
			nivel_1_aprobado = datos.get("nivel_1_aprobado", false)
			errores_nivel_1 = datos.get("errores_nivel_1", 0)
			errores_nivel_2 = datos.get("errores_nivel_2", 0)
			errores_nivel_3 = datos.get("errores_nivel_3", 0)
			preguntas_respondidas_nivel = datos.get("preguntas_respondidas_nivel", 0)
			npc_nivel3_respondido = datos.get("npc_nivel3_respondido", false)
			npc_traje_n3_respondido = datos.get("npc_traje_n3_respondido", false)
			
			# --- CARGAMOS LOS EVENTOS Y OBJETOS NUEVOS ---
			silva_ruta_k_respondida = datos.get("silva_ruta_k_respondida", false)
			hitos_nivel_2_completados = datos.get("hitos_nivel_2_completados", 0)
			recompensa_casa_roja_reclamada = datos.get("recompensa_casa_roja_reclamada", false)
			cofre_herreria_abierto = datos.get("cofre_herreria_abierto", false)
			rubia_dio_fruta_nivel = datos.get("rubia_dio_fruta_nivel", false)
			vidas_maximas = datos.get("vidas_maximas", 3)
			vidas_actuales = datos.get("vidas_actuales", 3)
			nivel_actual = datos.get("nivel_actual", 1)
			
			controles = datos.get("controles", "wasd")
			print("Partida cargada correctamente.")
			return true
	
	print("No hay partida guardada.")
	return false
# ==========================================
# SISTEMA DE REGISTRO DE DATOS (LOGS)
# ==========================================
const RUTA_LOG = "user://pixel_pointers_log.csv"
var id_jugador_actual = "jugador_anonimo" # Idealmente, esto se pediría al inicio

func inicializar_log():
	# Si el archivo NO existe, lo creamos y le ponemos la cabecera (los títulos de las columnas)
	if not FileAccess.file_exists(RUTA_LOG):
		var archivo = FileAccess.open(RUTA_LOG, FileAccess.WRITE)
		var cabecera = "timestamp,idJugador,nivel,pregunta,alternativas,respuestaJugador,siFueCorrectaoNo,tiempoDeRespuesta\n"
		archivo.store_string(cabecera)
		archivo.close()
		print("Archivo Log creado exitosamente.")

func registrar_interaccion(pregunta, alternativas_str, respuesta_jugador, fue_correcta, tiempo_segundos):
	# Obtenemos la fecha y hora exacta del sistema operativo
	var tiempo = Time.get_datetime_dict_from_system()
	var timestamp = str(tiempo.year) + "-" + str(tiempo.month).pad_zeros(2) + "-" + str(tiempo.day).pad_zeros(2) + " " + str(tiempo.hour).pad_zeros(2) + ":" + str(tiempo.minute).pad_zeros(2) + ":" + str(tiempo.second).pad_zeros(2)
	
	# Convertimos el booleano (true/false) a texto (1/0 o texto claro)
	var correcta_str = "1" if fue_correcta else "0"
	
	# Construimos la línea que se añadirá al Excel (separada por comas)
	# Limpiamos las comas internas de los textos para que no rompan el formato CSV
	var pregunta_limpia = pregunta.replace(",", ";") 
	var alternativas_limpias = alternativas_str.replace(",", ";")
	var respuesta_limpia = respuesta_jugador.replace(",", ";")
	
	var nueva_linea = timestamp + "," + id_jugador_actual + "," + str(nivel_actual) + "," + pregunta_limpia + "," + alternativas_limpias + "," + respuesta_limpia + "," + correcta_str + "," + str(tiempo_segundos) + "\n"
	
	# Abrimos el archivo en modo READ_WRITE (para no borrar lo anterior) y escribimos al final
	var archivo = FileAccess.open(RUTA_LOG, FileAccess.READ_WRITE)
	archivo.seek(archivo.get_length()) # Movemos el "cursor" al final del documento
	archivo.store_string(nueva_linea)
	archivo.close()
	print("Interacción registrada en el log.")
func _process(delta):
	tiempo_jugado += delta
