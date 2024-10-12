extends Node2D

@export var dialogueJson : JSON

var state : Dictionary = {
	"show_all_choices": false
}

#func _ready() -> void:
	#DialogueSystem.TriggerDialogueOptions(dialogueJson, self, %TailMarker, %BubbleMarker)
	#%Button1.pressed.connect(func():
		#DialogueSystem.TriggerDialogueBubble(["hello world! 1", "hello world! 2", "hello world! 3"], %TailMarker)
	#)
	#%Button2.pressed.connect(func():
		#DialogueSystem.TriggerDialogueBubble(["pleased to meet you 1", "pleased to meet you 2", "pleased to meet you 3"], %TailMarker)
	#)
	#%Button3.pressed.connect(func():
		#DialogueSystem.TriggerDialogueBubble(["What some candy? 1", "What some candy? 2", "What some candy? 3"], %TailMarker)
	#)
	

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not AutoDialogueGlobal.dialogueActive and event is InputEventMouseButton:
		if event.is_pressed():
			AutoDialogueGlobal.TriggerDialogueOptions(dialogueJson, self, %TailMarker, %BubbleMarker)
		
