extends Control
class_name DialogueWindow

## this is used by the DialogueSystem Global to capture mouse input while dialogue is active
## might not need it though

signal PlayerInput(input: InputEvent)

@onready var questionContainer: CenterContainer = %QuestionContainer
@onready var optionsContainer = %OptionsContainer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			PlayerInput.emit(event)
