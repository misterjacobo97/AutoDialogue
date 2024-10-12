extends Node
class_name AutoDialogue

## For the management of game dialogue, using the powerful addone 'EzDialogue' by Dev Ezra

enum CHAR_DISPLAY_SPEED { ## enum for accessing the type of chararacter in a text
	DEFAULT, ## any letter
	SPACE,
	PUNCTUATION ## characters like ,.!?
}

var letterSpeedDict := {
	CHAR_DISPLAY_SPEED.DEFAULT: 0.05,
	CHAR_DISPLAY_SPEED.SPACE: 0.02,
	CHAR_DISPLAY_SPEED.PUNCTUATION: 0.1
}

signal DialogueUpdated ## for when current dialogue is finsihed changed 

signal DialogueAdvanced
signal OptionSelected(questionEnum: int, questionText: String, optionEnum: GlobalEnumBus.DIALOGUE_OPTIONS, optionText: String )

var dialogueActive := false

@onready var dialogueSpeechBubbleWithChoices := preload("res://addons/autodialogue/DialogueBubble/DialogueSpeechBubbleWithChoices.tscn")
@onready var innactiveOptions : Array[GlobalEnumBus.DIALOGUE_OPTIONS] = []

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			DialogueAdvanced.emit()

## To show the dialogue bubble.
## The user should pass a bubble marker to choose the position of the bubble.
func TriggerDialogueOptions(dialogueJson: JSON, _parentRef: Node2D, tailMarker: Marker2D, bubbleMarker: Marker2D = null):
	dialogueActive = true
	
	var newChoiceBubble = dialogueSpeechBubbleWithChoices.instantiate() as DialogueSpeechBubbleWithChoices
	newChoiceBubble.parentRef = _parentRef
	
	newChoiceBubble.tailMarkerRef = tailMarker
	tailMarker.add_child(newChoiceBubble)
	
	if bubbleMarker:
		newChoiceBubble.bubbleMarkerRef = bubbleMarker
	
	newChoiceBubble.InitialiseDialogue(dialogueJson, _parentRef)

func TriggerDialogueFinished():
	dialogueActive = false

func TransitionCamera():
	pass
