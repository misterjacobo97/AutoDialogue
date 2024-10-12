extends Button
class_name ChoiceButton

signal choiceSelected(choiceIdx: int)

var choice_idx : int
var buttonText : String

func _ready() -> void:
	text = buttonText
	_SpawnAnimation()

func _on_pressed() -> void:
	choiceSelected.emit(choice_idx)

func _SpawnAnimation():
	var tween := create_tween().set_parallel(true)
	
	tween.tween_property(self, "modulate:a", 1, 0.4).from(0)
	#self.position.y += 20
	#tween.tween_property(self, "position:y", -20, 0.3).as_relative()
	
