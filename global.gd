extends Node

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
		"pregunta": "¿Qué almacena exactamente una variable de tipo puntero en C?",
		"correcta": "La dirección de memoria de otra variable.",
		"falsas": ["El valor de un dato entero o decimal.", "La cantidad de memoria RAM del programa."],
		"feedback": "Los punteros actúan como mapas; no guardan el tesoro, guardan las coordenadas de dónde está."
	},
	{
		"pregunta": "¿Qué símbolo se usa para obtener la dirección de memoria de una variable?",
		"correcta": "El operador de dirección (&).",
		"falsas": ["El operador de indirección (*).", "El operador de porcentaje (%)."],
		"feedback": "El ampersand (&) se lee como 'la dirección de'."
	},
	{
		"pregunta": "¿Qué acción define al término 'desreferenciación'?",
		"correcta": "Acceder o modificar el valor real almacenado en la dirección de memoria apuntada.",
		"falsas": ["Liberar definitivamente el espacio de memoria que ocupa el puntero.", "Multiplicar el valor de la variable por su propia dirección."],
		"feedback": "Se logra usando el asterisco (*) delante del puntero."
	},
	{
		"pregunta": "¿Qué representa conceptualmente la asignación de NULL a un puntero?",
		"correcta": "Indica explícitamente que no apunta a ninguna dirección de memoria válida.",
		"falsas": ["Asigna el valor numérico cero a la variable original.", "Borra automáticamente la variable original de la memoria."],
		"feedback": "NULL es la forma segura de decir 'este puntero está vacío por ahora'."
	},
	{
		"pregunta": "¿Qué se entiende por un 'puntero no inicializado'?",
		"correcta": "Un puntero declarado, pero sin una dirección de memoria asignada.",
		"falsas": ["Un puntero que cambia de dirección aleatoriamente.", "Un puntero exclusivo para caracteres."],
		"feedback": "Es muy peligroso, ya que apuntará a una zona de memoria aleatoria (basura)."
	},
	{
		"pregunta": "¿Qué tamaño en bytes ocupa usualmente un puntero en una arquitectura de 64 bits?",
		"correcta": "8 bytes.",
		"falsas": ["4 bytes.", "Depende del tipo de dato al que apunta."],
		"feedback": "Sin importar si apunta a un char (1 byte) o a un double (8 bytes), la dirección de memoria en sí siempre ocupa 8 bytes en 64 bits."
	},
	{
		"pregunta": "¿Cuál es la forma correcta de declarar un puntero a un número entero?",
		"correcta": "int *p;",
		"falsas": ["int p*;", "pointer int p;"],
		"feedback": "El tipo de dato seguido del asterisco define la declaración."
	},
	{
		"pregunta": "Si 'int x = 5;', ¿de qué tipo es la expresión '&x'?",
		"correcta": "int * (Puntero a entero).",
		"falsas": ["int", "No tiene tipo definido."],
		"feedback": "Al extraer la dirección de un int, obtienes un puntero a int."
	},
	{
		"pregunta": "¿Se puede sumar o restar valores numéricos directamente a un puntero?",
		"correcta": "Sí, se conoce como aritmética de punteros.",
		"falsas": ["No, los punteros son constantes inmutables.", "Solo si el puntero apunta a un float."],
		"feedback": "Sirve para navegar a través de arreglos de memoria contigua."
	},
	{
		"pregunta": "¿Qué significa el tipo de dato 'void *'?",
		"correcta": "Un puntero genérico sin tipo de dato asociado.",
		"falsas": ["Un puntero que automáticamente destruye su contenido.", "Un puntero que solo puede apuntar a funciones void."],
		"feedback": "Es útil para hacer funciones flexibles, pero debe ser casteado antes de desreferenciarlo."
	},
	{
		"pregunta": "¿Qué valor suele imprimir la función printf al usar el formato '%p'?",
		"correcta": "La dirección de memoria en formato hexadecimal.",
		"falsas": ["El valor contenido en binario.", "La cantidad de bytes usados."],
		"feedback": "Las direcciones de memoria se expresan tradicionalmente en base 16 (ej. 0x7ffd)."
	},
	{
		"pregunta": "Al declarar 'int *p1, p2;', ¿qué tipos de variables se crean?",
		"correcta": "p1 es puntero a int, p2 es un int normal.",
		"falsas": ["Ambos son punteros a int.", "Da un error de compilación."],
		"feedback": "El asterisco solo afecta a la variable que tiene inmediatamente a su derecha."
	},
	{
		"pregunta": "¿Qué ocurre si comparamos dos punteros así: 'p1 == p2'?",
		"correcta": "Verifica si ambos apuntan a la misma dirección de memoria.",
		"falsas": ["Verifica si los valores a los que apuntan son iguales.", "Da un error lógico siempre."],
		"feedback": "Compara coordenadas, no los datos almacenados en ellas."
	},
	{
		"pregunta": "Si 'p' vale NULL, ¿qué ocurre al ejecutar '*p = 10;'?",
		"correcta": "El programa colapsa (Segmentation Fault).",
		"falsas": ["Se crea la variable en memoria automáticamente.", "El programa ignora la instrucción y sigue."],
		"feedback": "No puedes escribir un dato en 'ninguna parte' (NULL)."
	},
	{
		"pregunta": "¿Puede un puntero apuntar a otro puntero?",
		"correcta": "Sí, se conoce como puntero múltiple o puntero doble.",
		"falsas": ["No, solo pueden apuntar a variables primitivas.", "Sí, pero solo en C++ y no en C."],
		"feedback": "Su sintaxis utiliza múltiples asteriscos, como int **p;"
	}
]

# ==========================================
# NIVEL 2: Punteros Dobles y Estructuras
# ==========================================
var preguntas_nivel_2 = [
	{
		"pregunta": "Completa la sintaxis: int num = 40; int *ptr = &num; ____ pptr = &ptr;",
		"correcta": "int **",
		"falsas": ["int *", "int &&"],
		"feedback": "Un puntero que guarda la dirección de otro puntero lleva dos asteriscos."
	},
	{
		"pregunta": "¿Qué operador debes usar sobre el puntero doble 'pptr' para modificar directamente 'num' a 50?",
		"correcta": "**pptr = 50;",
		"falsas": ["*pptr = 50;", "pptr = 50;"],
		"feedback": "El primer * te lleva al puntero intermedio, el segundo * te lleva al valor final."
	},
	{
		"pregunta": "Si int x = 10; int *p1 = &x; int **p2 = &p1; ¿qué retorna la expresión '*p2'?",
		"correcta": "La dirección de memoria de x.",
		"falsas": ["El valor 10.", "Un error de compilación."],
		"feedback": "Al desreferenciar p2 una sola vez, obtienes lo que guarda p1, que es la dirección de x."
	},
	{
		"pregunta": "Tienes int *array[5]; y un puntero int **ptr = array;. ¿Cómo accedes al número al que apunta el primer elemento?",
		"correcta": "*(*ptr)",
		"falsas": ["*ptr", "ptr[0]"],
		"feedback": "Como es un arreglo de punteros, necesitas doble desreferenciación para llegar al dato."
	},
	{
		"pregunta": "Si int datos[3] = {100, 200, 300}; int *ptr = datos; ptr++; ¿qué imprimirá *ptr?",
		"correcta": "200",
		"falsas": ["100", "Una dirección de memoria aleatoria."],
		"feedback": "El operador ++ hace que el puntero salte al siguiente bloque de memoria válido del arreglo."
	},
	{
		"pregunta": "Si 'ptr' apunta a un int (4 bytes) y haces 'ptr = ptr + 2;', ¿cuántos bytes avanza en memoria RAM?",
		"correcta": "8 bytes.",
		"falsas": ["2 bytes.", "4 bytes."],
		"feedback": "Avanza '2 espacios del tamaño del tipo de dato'. 2 * 4 bytes = 8 bytes."
	},
	{
		"pregunta": "En un string char *cadena = \"Hola\";, ¿a qué carácter apunta exactamente '*cadena'?",
		"correcta": "Al carácter 'H'.",
		"falsas": ["Al carácter 'a'.", "A toda la palabra 'Hola'."],
		"feedback": "Los strings en C son arreglos, y el puntero base siempre apunta a la primera posición (índice 0)."
	},
	{
		"pregunta": "Si 'p' apunta al inicio de un arreglo 'arr', ¿qué expresión es equivalente a 'arr[3]'?",
		"correcta": "*(p + 3)",
		"falsas": ["*p + 3", "p[4]"],
		"feedback": "Los corchetes son solo azúcar sintáctica para la suma de punteros y desreferenciación."
	},
	{
		"pregunta": "Tienes 'struct Nodo { int valor; };' y un puntero 'struct Nodo *p'. ¿Cómo accedes a 'valor'?",
		"correcta": "p->valor",
		"falsas": ["p.valor", "*p.valor"],
		"feedback": "El operador flecha (->) combina la desreferenciación y el acceso al atributo en un solo paso."
	},
	{
		"pregunta": "¿Qué diferencia hay entre '(*p)++' y '*p++'?",
		"correcta": "El primero suma 1 al dato, el segundo avanza el puntero de dirección.",
		"falsas": ["Hacen exactamente lo mismo.", "El primero da error de sintaxis."],
		"feedback": "El orden de precedencia de los operadores en C hace que los paréntesis cambien totalmente la lógica."
	},
	{
		"pregunta": "¿Es válido restar dos punteros del mismo tipo (ej. p2 - p1)?",
		"correcta": "Sí, devuelve la cantidad de elementos entre ellos.",
		"falsas": ["No, la resta de punteros no está permitida en C.", "Sí, devuelve la suma de sus valores apuntados."],
		"feedback": "Es muy útil para calcular el tamaño o la distancia dentro de un mismo arreglo."
	},
	{
		"pregunta": "¿Cómo debes pasar un puntero a una función si quieres que la función cambie a dónde apunta ese puntero?",
		"correcta": "Pasando un puntero doble (**).",
		"falsas": ["Pasando el puntero normal (*).", "Usando la palabra clave 'ref'."],
		"feedback": "Para modificar cualquier variable (incluso un puntero) por referencia, necesitas enviar su dirección."
	},
	{
		"pregunta": "¿Qué significa la declaración 'const int *p;'?",
		"correcta": "El valor apuntado no puede cambiar, pero el puntero sí puede moverse.",
		"falsas": ["El puntero está fijo, pero el valor puede cambiar.", "Ninguno de los dos puede cambiar."],
		"feedback": "Se lee como 'un puntero a un entero constante'."
	},
	{
		"pregunta": "¿Qué significa la declaración 'int * const p;'?",
		"correcta": "El puntero no puede moverse, pero el valor apuntado sí puede cambiar.",
		"falsas": ["El valor apuntado es fijo.", "Ninguno de los dos puede cambiar."],
		"feedback": "Se lee como 'un puntero constante a un entero'."
	},
	{
		"pregunta": "¿Qué es un puntero a función?",
		"correcta": "Un puntero que almacena la dirección donde reside el código ejecutable de una función.",
		"falsas": ["Una función que retorna un puntero.", "Una función escrita para manipular direcciones."],
		"feedback": "Permite pasar funciones como parámetros, muy usado en callbacks."
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
		"feedback": "Este es un 'Wild Pointer'. Intentas guardar un 10 en una memoria que no has reservado ni asignado."
	},
	{
		"pregunta": "Analiza: int arr[3] = {1,2,3}; int *p = arr; p += 5; *p = 10; ¿Qué error ocurre?",
		"correcta": "Desbordamiento de búfer (Buffer Overflow).",
		"falsas": ["Error de sintaxis en p += 5.", "El arreglo no puede ser asignado a un puntero."],
		"feedback": "Estás invadiendo memoria fuera de los límites del arreglo, lo que corromperá otros datos o crasheará el programa."
	},
	{
		"pregunta": "Se requiere liberar memoria dinámica. ¿Qué función falta? int *p = malloc(sizeof(int)); ... _____ (p);",
		"correcta": "free",
		"falsas": ["delete", "clear"],
		"feedback": "En C puro, todo lo reservado con malloc/calloc debe ser devuelto al sistema operativo con free."
	},
	{
		"pregunta": "int* f() { int local = 10; return &local; } ¿Cuál es el error crítico de este código?",
		"correcta": "Retorna un Dangling Pointer (la variable local se destruye).",
		"falsas": ["Falta inicializar con NULL.", "El retorno debería ser *local."],
		"feedback": "Las variables locales mueren cuando termina la función. Retornar su dirección es retornar una tumba."
	},
	{
		"pregunta": "int *p = malloc(sizeof(int)); free(p); *p = 5; ¿Qué problema causa este código?",
		"correcta": "Un error 'Use-After-Free' que provoca comportamiento indefinido.",
		"falsas": ["Un error de sintaxis al compilar.", "El valor de p se vuelve NULL automáticamente."],
		"feedback": "Usar memoria después de liberarla es una de las vulnerabilidades de seguridad más graves en C."
	},
	{
		"pregunta": "¿Qué ocurre si olvidas llamar a free() sobre memoria reservada que ya no vas a usar?",
		"correcta": "Se genera un Memory Leak (Fuga de memoria).",
		"falsas": ["El sistema la libera sola al cerrarse el ciclo for.", "Da un error de compilación de GCC."],
		"feedback": "El programa consumirá RAM de forma infinita hasta que el sistema operativo lo mate."
	},
	{
		"pregunta": "¿Cuál es la principal diferencia entre malloc y calloc?",
		"correcta": "calloc inicializa toda la memoria reservada con ceros.",
		"falsas": ["malloc es para int y calloc para floats.", "calloc libera la memoria anterior antes de reservar."],
		"feedback": "malloc es más rápido, pero calloc asegura que no tengas basura en la memoria al iniciar."
	},
	{
		"pregunta": "Tienes memoria reservada y la llenaste. Necesitas expandir su tamaño. ¿Qué función de la librería estándar usas?",
		"correcta": "realloc",
		"falsas": ["malloc_extend", "new_size"],
		"feedback": "realloc intenta expandir el bloque actual o busca uno nuevo grande y copia los datos antiguos ahí."
	},
	{
		"pregunta": "¿Qué retorna la función malloc si no hay más memoria RAM disponible en el sistema?",
		"correcta": "NULL",
		"falsas": ["Un número negativo (-1).", "Crashea el sistema operativo completo."],
		"feedback": "Por eso siempre debes verificar 'if (p == NULL)' después de hacer un malloc."
	},
	{
		"pregunta": "¿Qué sucede si haces un 'Double Free' (llamar a free dos veces sobre el mismo puntero)?",
		"correcta": "Corrupción del Heap y caída inminente del programa.",
		"falsas": ["No pasa nada, la segunda llamada es ignorada.", "Borra la variable que estaba justo después en la memoria."],
		"feedback": "El gestor de memoria del SO colapsa al intentar liberar algo que ya está marcado como libre."
	},
	{
		"pregunta": "Tienes 'char *p = \"Hola\";' y haces 'p[0] = 'h';'. ¿Por qué ocurre un Segmentation Fault?",
		"correcta": "Intentas modificar un dato alojado en memoria de solo lectura (Data Segment).",
		"falsas": ["Los strings en C no permiten minúsculas.", "Te faltó desreferenciar con asterisco primero."],
		"feedback": "Las cadenas literales se guardan en un segmento protegido. Para poder modificarla, deberías declararla como char p[] = \"Hola\";."
	},
	{
		"pregunta": "¿Qué herramienta externa es el estándar en entornos Linux para detectar Memory Leaks en C?",
		"correcta": "Valgrind",
		"falsas": ["GCC", "GDB"],
		"feedback": "Valgrind intercepta y rastrea todas tus llamadas a malloc y free."
	},
	{
		"pregunta": "¿Qué significa el error común de 'Stack Overflow' en tiempo de ejecución?",
		"correcta": "Agotamiento de la pila de memoria, usualmente por recursión infinita.",
		"falsas": ["El disco duro se quedó sin espacio para el ejecutable.", "Se ingresaron demasiados datos con scanf."],
		"feedback": "Las variables locales y las llamadas a funciones se apilan. Si la pila llega al límite, el SO aborta el programa."
	},
	{
		"pregunta": "¿Por qué es una buena práctica de seguridad hacer 'p = NULL;' justo después de usar 'free(p);'?",
		"correcta": "Para evitar dejar un Dangling Pointer accidental.",
		"falsas": ["Para devolver más rápido la memoria al disco duro.", "Porque C requiere esta instrucción por estándar IEEE."],
		"feedback": "Si luego, por error, intentas desreferenciar p, crasheará al instante en lugar de corromper datos de forma silenciosa."
	},
	{
		"pregunta": "¿En qué región de la memoria RAM del programa trabajan las funciones malloc/free?",
		"correcta": "El Heap (Montículo).",
		"falsas": ["El Stack (Pila).", "El Text Segment (Código de instrucciones)."],
		"feedback": "El Heap es la piscina gigante de memoria dinámica donde tú, el programador, gestionas la vida y muerte de los datos."
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

func _process(delta):
	tiempo_jugado += delta
