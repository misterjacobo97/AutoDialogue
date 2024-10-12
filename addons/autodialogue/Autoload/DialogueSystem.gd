extends CanvasLayer
class_name AutoDialogue

## For the management of game dialogue, to be used as Autoload and 
## called upon when wanting to display any type of dialogue.

enum CHAR_DISPLAY_SPEED { ## enum for accessing the type of chararacter in a text
	DEFAULT, ## any letter
	SPACE, ## special characters like !#%
	PUNCTUATION ## characters like ,.;
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

#@onready var dialogueWindow : DialogueWindow = $DialogueWindow
@onready var dialogueSpeechBubbleWithChoices := preload("res://addons/autodialogue/DialogueBubble/DialogueSpeechBubbleWithChoices.tscn")

@onready var innactiveOptions : Array[GlobalEnumBus.DIALOGUE_OPTIONS] = []

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			DialogueAdvanced.emit()

func _ready() -> void:
	%DialogueWindow.hide()
	
	#%DialogueWindow.PlayerInput.connect(func(event):
		#DialogueAdvanced.emit()
	#)

## To show the dialogue options node.
func TriggerDialogueOptions(dialogueJson: JSON, _parentRef: Node2D, tailMarker: Marker2D, bubbleMarker: Marker2D = null):
	dialogueActive = true
	%DialogueWindow.show()
	
	var newChoiceBubble = dialogueSpeechBubbleWithChoices.instantiate() as DialogueSpeechBubbleWithChoices
	newChoiceBubble.parentRef = _parentRef
	
	newChoiceBubble.tailMarkerRef = tailMarker
	tailMarker.add_child(newChoiceBubble)
	
	if bubbleMarker:
		newChoiceBubble.bubbleMarkerRef = bubbleMarker
	#
	#else:
		#dialogueWindow.add_child(newChoiceBubble)
	
	newChoiceBubble.InitialiseDialogue(dialogueJson, _parentRef)

## Resets the dialogue system and hides the DialogueWindow node
func TriggerDialogueFinished():
	dialogueActive = false
	%DialogueWindow.hide()
