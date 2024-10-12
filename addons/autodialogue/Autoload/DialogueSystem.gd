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

signal DialogueAdvanced
signal OptionSelected(questionEnum: int, questionText: String, optionEnum: GlobalEnumBus.DIALOGUE_OPTIONS, optionText: String )

signal DialogueFinished

var dialogueActive := false

@onready var dialogueSpeechBubbleWithChoices := preload("res://addons/autodialogue/DialogueBubble/DialogueSpeechBubbleWithChoices.tscn")
@onready var innactiveOptions : Array[GlobalEnumBus.DIALOGUE_OPTIONS] = []

var cameraTween : Tween
var mainCameraRef : Camera2D = null

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
	if mainCameraRef:
		TransitionCamera(mainCameraRef)
	
	DialogueFinished.emit()

## A way to transition a Camera2D to the position of another one when dialogue is triggered
func TransitionCamera(newCamera: Camera2D, mainCamera: Camera2D = null):
	if mainCamera:
		mainCameraRef = mainCamera
		
		%TransitionCamera2D.global_position = mainCamera.global_position
		%TransitionCamera2D.scale = mainCamera.scale
		%TransitionCamera2D.zoom = mainCamera.zoom
	
	%TransitionCamera2D.make_current()
	
	if cameraTween and cameraTween.is_running():
		cameraTween.kill()
	
	cameraTween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN)
	
	cameraTween.tween_property(%TransitionCamera2D, "global_position", newCamera.global_position, 0.8).from_current()
	cameraTween.tween_property(%TransitionCamera2D, "zoom", newCamera.zoom, 0.8).from_current()
	cameraTween.tween_property(%TransitionCamera2D, "rotation", newCamera.rotation, 0.8).from_current()
	
	await cameraTween.finished
	newCamera.make_current()
