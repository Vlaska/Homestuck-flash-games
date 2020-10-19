tool
extends EditorPlugin


var panel
func _enter_tree():
	panel = PanelContainer.new()
	var b = Button.new()
    panel.add_child(b)
    get_editor_interface().add_control_to_container(CONTAINER_TOOLBAR, panel)