extends Control

@export var color_seleccionado = Color8(0,0,0,255)

func salirPopup() -> void:
	$"/root/main/editorNota".actualizar_color(color_seleccionado)
	visible = false

func _on_button_popup_ninguno_button_up() -> void:
	$/root/main/popupColores.visible = false

func _on_fondopopup_gui_input(event) -> void:
	if event is InputEventMouseButton:
		$/root/main/popupColores.visible = false

func _on_button_popup_gris_button_up() -> void:
	color_seleccionado = Global.GRIS
	salirPopup()

func _on_button_popup_rojo_button_up() -> void:
	color_seleccionado = Global.ROJO
	salirPopup()

func _on_button_popup_azul_button_up() -> void:
	color_seleccionado = Global.AZUL
	salirPopup()

func _on_button_popup_verde_button_up() -> void:
	color_seleccionado = Global.VERDE
	salirPopup()

func _on_button_popup_amarillo_button_up() -> void:
	color_seleccionado = Global.AMARILLO
	salirPopup()

func _on_button_popup_morado_button_up() -> void:
	color_seleccionado = Global.MORADO
	salirPopup()

func _on_button_popup_naranjo_button_up() -> void:
	color_seleccionado = Global.ANARANJADO
	salirPopup()
