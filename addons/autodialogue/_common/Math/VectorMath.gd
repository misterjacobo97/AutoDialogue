extends Resource
class_name VectorMath

func TurnNormalizedVector90DegClockwise(vec: Vector2) -> Vector2:
	## this assume the y coord is inverted - as it is in Godot
	var newVec = Vector2(-vec.y, vec.x)
	
	return newVec

func TurnNormalizedVector90DegAntiClockwise(vec: Vector2) -> Vector2:
	## this assume the y coord is inverted - as it is in Godot
	var newVec = Vector2(vec.y, -vec.x)
	
	return newVec
