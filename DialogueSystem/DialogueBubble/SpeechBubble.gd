extends PanelContainer
class_name DialogueBubble

@export var bubbleText : String
var currentLetterIdx : int = 0

@export var letterTimer : Timer

func _process(delta: float) -> void:
	if (
		%RichTextLabel.text != bubbleText and
		letterTimer.is_stopped() and
		currentLetterIdx < bubbleText.length()
	):
		letterTimer.start(0.1)
		%RichTextLabel.append_text(bubbleText[currentLetterIdx])
		
		currentLetterIdx += 1

func ChangeBubbleText(newText: String):
	ClearBubbleText()
	bubbleText = newText
	SetMinimumBoxSize()

func ClearBubbleText():
	currentLetterIdx = 0
	bubbleText = ""
	%RichTextLabel.clear()
	%RichTextLabel.append_text("[center]")

func SkipTextAnimation():
	## to skip the slower animation in case a player clicks while its running
	if currentLetterIdx < bubbleText.length():
		currentLetterIdx = bubbleText.length()
		%RichTextLabel.clear()
		%RichTextLabel.append_text("[center]" + bubbleText)

func SetMinimumBoxSize():
	var x = bubbleText
	var m = ""
	
	for i in x.split("\n"):
		if i.length() > m.length():
			m = i
	
	var font := (%RichTextLabel as RichTextLabel).get_theme_default_font()
	var size := font.get_string_size(m)
	
	self.custom_minimum_size.x = size.x + 16
	self.custom_minimum_size.y = x.split("\n").size() * size.y + (16)
