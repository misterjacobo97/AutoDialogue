extends Node2D

#@onready var innactiveOptions : Array[GlobalEnumBus.DIALOGUE_OPTIONS] = [1]
#@onready var dialogue_window: DialogueWindow = null:
	#set(value):
		#dialogue_window = value
		#UpdateDialogue()
#
#func UpdateDialogue() -> void:
	#DialogueSystem.AddDialogueWindow(dialogue_window)
	#DialogueSystem.AddOption("A", GlobalEnumBus.DIALOGUE_OPTIONS.A)
	#DialogueSystem.AddOption("B", GlobalEnumBus.DIALOGUE_OPTIONS.B)
	#DialogueSystem.AddOption("C", GlobalEnumBus.DIALOGUE_OPTIONS.C)
	#DialogueSystem.AddOption("D", GlobalEnumBus.DIALOGUE_OPTIONS.D)
	#
	#DialogueSystem.UpdateDialogueWindow()
	#
	#DialogueSystem.OptionSelected.connect(func(questionEnum: int, questionText: String, optionEnum: GlobalEnumBus.DIALOGUE_OPTIONS, optionText: String ):
		#print(optionEnum, optionText)
	#)
