extends Control

var notas_en_disco: Array
var nota_eliminada: String

func _ready() -> void:
	$body/Label.text = Global.Fecha
	$vistaBuscar.visible = false
	$editorNota.visible = false
	$popupColores.visible = false
	$apartadoEliminadas.visible = false
	$LabelAvisoGuardado.text = str(Time.get_ticks_msec())
	cargar_notas_previas_desde_disco()

func _notification(what) -> void:
	if what == NOTIFICATION_FOCUS_EXIT:
		print("perdio foco")
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if $editorNota.visible or $vistaBuscar.visible or $popupColores.visible or $apartadoEliminadas.visible:
			if $apartadoEliminadas.visible and $editorNota.visible:
				pass
		else:
			get_tree().quit()

	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if $vistaBuscar.visible == true:
			$vistaBuscar.visible = false
		if $editorNota.visible == true:
			if $editorNota/Panel/ButtonAsignarColorEditor.visible == true:
				$editorNota.modo_lectura()
				$editorNota.editor_guardar_y_salir()
			if $editorNota/Panel/ButtonPapeleraEliminar.visible == true:
				$editorNota.visible = false
		if $popupColores.visible == true:
			$popupColores.visible = false
		if $apartadoEliminadas.visible == true:
			$apartadoEliminadas.visible = false

func cargar_notas_previas_desde_disco() -> void:
	notas_en_disco = Global.verificador_notas_en_disco()
	print(notas_en_disco)
	for n in notas_en_disco:
		nueva_nota(false,n)
	print("carga de archivos terminada")

func nueva_nota(crear_nueva:bool,notaEnDisco:String) -> void:
	#  si el argumento es "true", quiere decir que se esta creando desde el boton + 
	#  si es false, quiere decir que se va a crear una nota con datos ya existentes en disco
	var nuevo_hijo = $body/ScrollContainer/VBoxContainer.my_scene.instantiate()
	if crear_nueva:
		get_node(Global.RUTA_NODO_LISTA).add_child(nuevo_hijo,true)
		$editorNota.modo_escritura(get_node(Global.RUTA_NODO_LISTA).get_child(-1).name)
		$editorNota.visible = true
		$editorNota/ScrollContainer/TextEdit.grab_focus()
	else:
		var retorno = Global.leer_archivo_txt(notaEnDisco)
		var titulo = retorno["titulo"]
		var fecha_mod = retorno["fecha_mod"]
		var color = retorno["color"]
		var en_papelera = retorno["en_papelera"]
		if en_papelera:
			color = Global.NEGRO_PREDETERMINADO
			get_node(Global.RUTA_NODO_ELIMINADAS).add_child(nuevo_hijo,true)
			get_node(Global.RUTA_NODO_ELIMINADAS).get_child(-1).name = notaEnDisco
			get_node(Global.RUTA_NODO_ELIMINADAS).get_child(-1).en_papelera = true
			get_node(Global.RUTA_NODO_ELIMINADAS + notaEnDisco).actualizar_nota_enlistada(titulo,color,fecha_mod)
		else:
			get_node(Global.RUTA_NODO_LISTA).add_child(nuevo_hijo)
			get_node(Global.RUTA_NODO_LISTA).get_child(-1).name = notaEnDisco
			get_node(Global.RUTA_NODO_LISTA + notaEnDisco).actualizar_nota_enlistada(titulo,color,fecha_mod)

func buscar_nota() -> void:
	$vistaBuscar.visible = true
	$vistaBuscar/LineEdit.grab_focus()
	$vistaBuscar/LineEdit/ButtonClearBuscar.visible = false

#  Input boton crear
func _on_button_crear_nota_main_button_up() -> void:
	nueva_nota(true,"")

#  Input boton buscar
func _on_button_buscar_main_button_up() -> void:
	buscar_nota()

#  Input campo buscar nota
func _on_line_edit_text_changed(new_text) -> void:
	if new_text != null:
		$vistaBuscar/LineEdit/ButtonClearBuscar.visible = true
	if new_text == "":
		$vistaBuscar/LineEdit/ButtonClearBuscar.visible = false

#  Input limpiar campo buscar nota
func _on_button_clear_buscar_button_up() -> void:
	$vistaBuscar/LineEdit.text = ""
	$vistaBuscar/LineEdit/ButtonClearBuscar.visible = false

func _on_button_grid_button_up() -> void:
	$popupColores.visible = true

func _on_button_opciones_main_button_up() -> void:
	$apartadoEliminadas.visible = true

func _input(_event) -> void:
	if Input.is_action_pressed("ui_cancel"):
		_notification(NOTIFICATION_WM_GO_BACK_REQUEST)

func _on_line_edit_gui_input(event) -> void:
	if event is InputEventKey:
		$vistaBuscar/Label.text = event.as_text_keycode()
