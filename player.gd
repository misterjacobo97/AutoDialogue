extends Node2D

@export var dialogueJson : JSON

var state : Dictionary = {
	"show_all_choices": false
}

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not AutoDialogueGlobal.dialogueActive and event is InputEventMouseButton:
		if event.is_pressed():
			AutoDialogueGlobal.TriggerDialogueOptions(dialogueJson, self, %TailMarker, %BubbleMarker)
			AutoDialogueGlobal.TransitionCamera($"../NewCamera2D", $"../MainCamera2D")
