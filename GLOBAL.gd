extends Node

var DictHoraFecha = Time.get_datetime_dict_from_system()
var Fecha: String
var ROJO: Color = Color8(184,55,57,255)
var VERDE: Color = Color8(82,214,79,255)
var AZUL: Color = Color8(79,122,214,255)
var AMARILLO: Color = Color8(183,214,79,255)
var GRIS: Color = Color8(66,71,82,255)
var MORADO: Color = Color8(162,61,196,255)
var ANARANJADO: Color = Color8(235,140,33,255)
var NEGRO_PREDETERMINADO: Color = Color8(33,35,41,255)
var RUTA_NODO_LISTA: String = "/root/main/body/ScrollContainer/VBoxContainer/"
var RUTA_ARCHIVOS: String = "user://"

func _ready() -> void:
	formato_fecha()
	get_tree().root.disable_3d = true

func formato_fecha() -> void:
	Fecha = str(DictHoraFecha.day)
	Fecha = Fecha + "/" + str(DictHoraFecha.month)
	Fecha = Fecha + "/" + str(DictHoraFecha.year)

	#  crear archivo
func guardar_en_archivo_txt(content,referenciaNota,tituloNota,color,fechaMod) -> void:
	if content == null:
		content = ""
	var archivo = ConfigFile.new()
	archivo.set_value("contenido","contenido", content)
	archivo.set_value("contenido","titulo_nota",tituloNota)
	archivo.set_value("contenido","color",color)
	archivo.set_value("contenido","fechaModificacion",fechaMod)
	print(archivo.encode_to_text())
	if archivo.save("user://" + referenciaNota) != OK:
		print("error")
	else:
		print("guardado completado")

func leer_archivo_txt(referenciaNota) -> Dictionary:
	var content
	var color
	var titulo
	var fecha_mod
	var diccionario_retorno: Dictionary
	var archivo = ConfigFile.new()
	if archivo.load("user://" + referenciaNota) != OK:
		print("error al leer archivo")
	else:
		content = archivo.get_value("contenido", "contenido")
		titulo = archivo.get_value("contenido", "titulo_nota")
		color = archivo.get_value("contenido", "color")
		fecha_mod = archivo.get_value("contenido","fechaModificacion")
		diccionario_retorno = {"contenido":content, "titulo":titulo, "color":color, "fecha_mod":fecha_mod}
	return diccionario_retorno

func verificador_notas_en_disco() -> Array:
	#  devuelve una lista con los archivos encontrados
	var nombre_archivos: String = "PanelNota"
	var notas_encontradas: Array = []
	var archivo = ConfigFile.new()
	for n in range(1,61):
		if archivo.load(RUTA_ARCHIVOS + nombre_archivos + str(n)) == OK:
			notas_encontradas.append(nombre_archivos + str(n))
		else:
			pass
	return notas_encontradas
