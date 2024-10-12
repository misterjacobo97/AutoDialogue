extends Control
class_name DialogueSpeechBubbleWithChoices

@export var dialogueJsonPath : JSON
var parentRef: Node2D
var tailMarkerRef : Marker2D
var bubbleMarkerRef : Marker2D
 
@onready var choiceButton := preload("res://addons/autodialogue/DialogueBubble/ChoiceButton.tscn")
var choiceButtonArr : Array[ChoiceButton] = []

@export var SIE : SemiImplicitEuler
@export var bubbleSpawnSpeed := 0.05

func _ready() -> void:
	AutoDialogueGlobal.DialogueAdvanced.connect(_OnDialogueAdvanced)
	
	## for the wobble animation when text changes
	SIE.SecondOrderDynamics(tailMarkerRef.global_position)#(get_parent() as Marker2D).global_position)

func _physics_process(delta: float) -> void:
	var targetPos
	if bubbleMarkerRef:
		targetPos = bubbleMarkerRef.global_position
	else:
		targetPos = (get_parent() as Marker2D).global_position + Vector2(50, -50)
	
	%VBoxContainer.global_position = SIE.UpdateDynamics(bubbleSpawnSpeed, targetPos)
	UpdateTail()

## to be called by the entity who wants to initiate dialogue
func InitialiseDialogue(dialogueJson: JSON, _parentRef: Node2D):
	parentRef = _parentRef
	(%EzDialogue as EzDialogue).start_dialogue(dialogueJsonPath, _parentRef.state)

func ClearDialogueBubble():
	(%DialogueBubble as DialogueBubble).ClearBubbleText()
	for button in choiceButtonArr:
		%ButtonsVBox.remove_child(button)
	
	choiceButtonArr = []

func AddText(newText: String):
	SIE.SecondOrderDynamics(tailMarkerRef.global_position)#(get_parent() as Marker2D).global_position)
	(%DialogueBubble as DialogueBubble).ChangeBubbleText(newText)

func AddChoice(choiceString: String):
	var newChoiceButton : ChoiceButton = choiceButton.instantiate()
	newChoiceButton.choice_idx = choiceButtonArr.size()
	newChoiceButton.buttonText = choiceString
	
	choiceButtonArr.push_back(newChoiceButton)
	newChoiceButton.choiceSelected.connect(_OnChoiceSelected)
	%ButtonsVBox.add_child(newChoiceButton)

func UpdateTail():
	var diagContainer = %SpeechBubbleTail.to_local((%DialogueBubble as DialogueBubble).global_position)
	var tailYOffset = diagContainer.y - (-1 * %DialogueBubble.custom_minimum_size.y)
	var startPos = Vector2(diagContainer.x, tailYOffset)
	var endPos = Vector2(startPos.x + %DialogueBubble.custom_minimum_size.x / 4 , tailYOffset)
	
	var data : PackedVector2Array = [
		position,
		startPos,
		endPos
	]
	
	%SpeechBubbleTail.polygon = data

func _OnDialogueAdvanced():
	%DialogueBubble.SkipTextAnimation()

func _OnChoiceSelected(choiceIdx: int):
	(%EzDialogue as EzDialogue).next(choiceIdx)

func _on_ez_dialogue_dialogue_generated(response: DialogueResponse) -> void:
	#DialogueSystem.dialogueActive = true
	ClearDialogueBubble()
	
	AddText(response.text)
	
	if response.choices.is_empty():
		AddChoice("...")
	else:
		for choice in response.choices:
			AddChoice(choice)
			#await get_tree().create_timer(0.1).timeout

func _on_ez_dialogue_custom_signal_received(value: Variant) -> void:
	#print(value)
	var params = value.split(',')
	var state = parentRef.state
	
	if params[0] == "set":
		# set state param
		var paramName = params[1]
		var newParamState = params[2] == "true" if true else false
		
		state[paramName] = newParamState
		print(state)
		

func _on_ez_dialogue_end_of_dialogue_reached() -> void:
	AutoDialogueGlobal.TriggerDialogueFinished()
	queue_free()
