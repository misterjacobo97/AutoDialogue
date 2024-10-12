@tool
extends EditorPlugin

var ezDialoguePlugin = preload("res://addons/autodialogue/addons/ez_dialogue/ez_dialogue.gd").new()

## EzDialogue section
const MainPanel = preload("res://addons/autodialogue/addons/ez_dialogue/main_screen/main.tscn")
const PLUGIN_NAME = "EzDialogue"
const DIALOGUE_NODE_NAME = "EzDialogue"
const ICON = preload("addons/ez_dialogue/icon.png")

var main_panel_instance: MainDiagPanel


func _enter_tree() -> void:
	## EZ_DIALOGUE
	add_custom_type(DIALOGUE_NODE_NAME, "Node", preload("addons/ez_dialogue/ez_dialogue_node.gd"), ICON)

	main_panel_instance = MainPanel.instantiate()
	
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)

	# Hide the main panel
	_make_visible(false)
	
	## MAIN PLUGIN
	add_autoload_singleton("AutoDialogueGlobal", "res://addons/autodialogue/Autoload/DialogueSystem.tscn")

func _exit_tree() -> void:
	## MAIN PLUGIN
	remove_autoload_singleton("AutoDialogueGlobal")
	
	## EZ DIALOGUE
	remove_custom_type(DIALOGUE_NODE_NAME)
	if main_panel_instance:
		main_panel_instance.queue_free()

func _ready():
	pass

func _has_main_screen():
	return true

func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible

func _get_plugin_name():
	return PLUGIN_NAME
	
func _get_plugin_icon():
	return ICON

func _save_external_data():
	main_panel_instance.save()
