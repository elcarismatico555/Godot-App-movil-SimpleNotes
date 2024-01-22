extends Control

var escribiendo_texto: String = ""
var editandoNota: String = ""
var titulo: String = ""
var color_nota = Global.NEGRO_PREDETERMINADO
var fecha_modificacion: String = ""
var nota_en_papelera: bool = false

func _ready():
	$Panel/ColorRectEditorNota.color = Global.NEGRO_PREDETERMINADO
	$Panel/ButtonAsignarColorEditor/ColorRectAsignarColorEditor.color = Global.NEGRO_PREDETERMINADO

func editor_guardar_y_salir() -> void:
	#  Al salir del editor de la nota, se asignan los valores a las variables que se guardaran en disco
	#  y se llama a la funcion que actualiza la visualizacion de la nota enlistada
	escribiendo_texto = $ScrollContainer/TextEdit.text
	color_nota[0] = $Panel/ColorRectEditorNota.color.r8
	color_nota[1] = $Panel/ColorRectEditorNota.color.g8
	color_nota[2] = $Panel/ColorRectEditorNota.color.b8
	color_nota[3] = $Panel/ColorRectEditorNota.color.a8
	if not $Panel/LabelTituloNota.text == "":
		titulo = $Panel/LabelTituloNota.text
	else:
		titulo = "(sin nombre)"
		$Panel/LabelTituloNota.text = "(sin nombre)"
	fecha_modificacion = Global.Fecha
	if get_node_or_null(Global.RUTA_NODO_LISTA + editandoNota) != null:
		get_node(Global.RUTA_NODO_LISTA + editandoNota).actualizar_nota_enlistada(titulo,color_nota,fecha_modificacion)
	if get_node_or_null(Global.RUTA_NODO_ELIMINADAS + editandoNota) != null:
		get_node(Global.RUTA_NODO_ELIMINADAS + editandoNota).actualizar_nota_enlistada(titulo,color_nota,fecha_modificacion)
	#  posiblemente podria añadir aqui algo para pisar el archivo vacio
	Global.guardar_en_archivo_txt(escribiendo_texto,editandoNota,titulo,color_nota,fecha_modificacion,nota_en_papelera)
	#  de aqui hacia abajo se resetean los valores para que la proxima vez que se habra el editor
	#  sea segun los datos guardaddos
	$Panel/ButtonAsignarColorEditor/ColorRectAsignarColorEditor.color = Global.NEGRO_PREDETERMINADO
	$Panel/ColorRectEditorNota.color = Global.NEGRO_PREDETERMINADO
	$ScrollContainer/TextEdit.text = ""
	$Panel/LineEditTituloNota.text = ""
	$Panel/LabelTituloNota.text = ""
	#editandoNota = ""
	titulo = ""
	color_nota = Global.NEGRO_PREDETERMINADO
	fecha_modificacion = ""
	visible = false

func editar_nota(nombreNota,papelera) -> void:
	#  Se llama a esta funcion cuando se presiona una nota enlistada pasandole su nombre
	#  para luego abrir el editor de notas segun la info guardada de la nota presionada
	#  ademas comprueba si la nota presionada esta en papelera, lo que definira su color por defecto
	nota_en_papelera = papelera
	editandoNota = nombreNota
	var retorno = Global.leer_archivo_txt(nombreNota)
	$ScrollContainer/TextEdit.text = retorno["contenido"]
	$Panel/LabelTituloNota.text = retorno["titulo"]
	if nota_en_papelera:
		$Panel/ColorRectEditorNota.color.r8 = Global.NEGRO_PREDETERMINADO[0]
		$Panel/ColorRectEditorNota.color.g8 = Global.NEGRO_PREDETERMINADO[1]
		$Panel/ColorRectEditorNota.color.b8 = Global.NEGRO_PREDETERMINADO[2]
		$Panel/ColorRectEditorNota.color.a8 = Global.NEGRO_PREDETERMINADO[3]
		modo_lectura_en_papelera()
	else:
		$Panel/ColorRectEditorNota.color.r8 = retorno["color"][0]
		$Panel/ColorRectEditorNota.color.g8 = retorno["color"][1]
		$Panel/ColorRectEditorNota.color.b8 = retorno["color"][2]
		$Panel/ColorRectEditorNota.color.a8 = retorno["color"][3]
		$Panel/ButtonAsignarColorEditor/ColorRectAsignarColorEditor.color = $Panel/ColorRectEditorNota.color
		modo_lectura()

func modo_escritura(nombreNota) -> void:
	editandoNota = nombreNota
	$Panel/LineEditTituloNota.text = $Panel/LabelTituloNota.text
	$Panel/LineEditTituloNota.visible = true
	$ScrollContainer/TextEdit.editable = true
	$ScrollContainer/TextEdit.virtual_keyboard_enabled = true
	$Panel/ButtonEditarNotaEditor.visible = false
	$Panel/ButtonEliminarNotaEditor.visible = false
	$Panel/ButtonAsignarColorEditor.visible = true
	$Panel/LabelTituloNota.visible = false
	$ScrollContainer/TextEdit.grab_focus()
	#print("escritura")

func modo_lectura() -> void:
	$ScrollContainer/TextEdit.editable = false
	$ScrollContainer/TextEdit.virtual_keyboard_enabled = false
	$Panel/ButtonAsignarColorEditor.visible = false
	$Panel/LineEditTituloNota.visible = false
	$Panel/ButtonEditarNotaEditor.visible = true
	$Panel/ButtonEliminarNotaEditor.visible = true
	$Panel/LabelTituloNota.visible = true
	#print("lectura")

func modo_lectura_en_papelera() -> void:
	$ScrollContainer/TextEdit.editable = false
	$ScrollContainer/TextEdit.virtual_keyboard_enabled = false
	$Panel/ButtonAsignarColorEditor.visible = false
	$Panel/LineEditTituloNota.visible = false
	$Panel/ButtonEditarNotaEditor.visible = false
	$Panel/ButtonEliminarNotaEditor.visible = false
	$Panel/ButtonPapeleraEliminar.visible = true
	$Panel/ButtonPapeleraRestaurar.visible = true

func actualizar_color(color) -> void:
	$Panel/ColorRectEditorNota.color = color
	#$ScrollContainer/TextEdit/TextEditGuias
	$Panel/ButtonAsignarColorEditor/ColorRectAsignarColorEditor.color = color

func _on_button_editar_nota_editor_button_up() -> void:
	modo_escritura(editandoNota)

func _on_button_eliminar_nota_editor_button_up() -> void:
	nota_en_papelera = true
	editor_guardar_y_salir()
	get_node(Global.RUTA_NODO_LISTA + editandoNota).enviar_a_papelera()
	$/root/main/editorNota.visible = false

func _on_button_asignar_color_editor_button_up() -> void:
	$/root/main/popupColores.visible = true

func _on_line_edit_titulo_nota_text_changed(new_text) -> void:
	$Panel/LineEditTituloNota.text = new_text
	$Panel/LabelTituloNota.text = new_text
	titulo = new_text
	var lista_string: StringName = new_text
	$Panel/LineEditTituloNota.caret_column = lista_string.length() + 1

func _on_button_papelera_restaurar_button_up():
	nota_en_papelera = false
	editor_guardar_y_salir()
	get_node(Global.RUTA_NODO_ELIMINADAS + editandoNota).restaurar()
	visible = false

func _on_button_papelera_eliminar_button_up():
	Global.vaciar_archivo(editandoNota)
	get_node(Global.RUTA_NODO_ELIMINADAS + editandoNota).queue_free()
	visible = false
