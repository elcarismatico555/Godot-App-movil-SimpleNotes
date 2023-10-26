extends Panel

var titulo: String = ""
var fecha_modificacion: String = ""
var color_nota = Color8(0,0,0,255)
var contenito: String = ""
var en_papelera: bool = false

func _ready() -> void:
	color_nota = Global.NEGRO_PREDETERMINADO
	$HBoxContainer/LabelTitulo.text = "(sin nombre)"

#  Al presionar la nota desde la lista
func _on_button_nota_enlistada_button_up() -> void:
	$/root/main/editorNota.editar_nota(name,en_papelera)
	$/root/main/editorNota.visible = true

func actualizar_nota_enlistada(tituloNota,color,fechaMod) -> void:
	$HBoxContainer/LabelTitulo.text = tituloNota
	$LabelFechaModificacion.text = fechaMod
	$HBoxContainer/ColorRect.color.r8 = color[0]
	$HBoxContainer/ColorRect.color.g8 = color[1]
	$HBoxContainer/ColorRect.color.b8 = color[2]
	$HBoxContainer/ColorRect.color.a8 = color[3]

func enviar_a_papelera():
	$HBoxContainer/ColorRect.color.r8 = Global.NEGRO_PREDETERMINADO[0]
	$HBoxContainer/ColorRect.color.g8 = Global.NEGRO_PREDETERMINADO[1]
	$HBoxContainer/ColorRect.color.b8 = Global.NEGRO_PREDETERMINADO[2]
	$HBoxContainer/ColorRect.color.a8 = Global.NEGRO_PREDETERMINADO[3]
	en_papelera = true
	reparent(Global.NODO_LISTA_ELIMINADAS)

func restaurar():
	en_papelera = false
	reparent(Global.NODO_LISTA)
