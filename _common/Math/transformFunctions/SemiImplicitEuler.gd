extends Resource
class_name SemiImplicitEuler

@export_category("dynamics")
## second order dynamics vars
var xp : Vector2
var y : Vector2
var yd : Vector2

# constants
var k1 : float
var k2 : float
var k3 : float

@export_range(0,1) var f : float = 0.5
@export_range(0,1) var z : float = 0.5
@export_range(0,1) var r : float = 0.5

# set target position to the global position of a node other than the one that will be moving, like the parent

func SecondOrderDynamics(target_start_position : Vector2):#f : float, z : float, r : float, target_start_position : Vector2):
	## z to control how subtle the behavious is
	## r to control the initial response
	## f to control how fast the system behaves
	
	# compute the constants
	RecalcConstants()#f, z, r, target_start_position)
	
	# initialize
	xp = target_start_position
	y = target_start_position
	yd = Vector2.ZERO

# to be able to change it during play time - we can recalc the constants
func RecalcConstants():#target_start_position : Vector2):#f : float, z : float, r : float, target_start_position : Vector2):
	k1 = z / (f * PI)
	k2 = 1 / ((2 * PI * f) * (2 * PI * f))
	k3 = r * z / (2 * PI * f)

func UpdateDynamics(time: float, target_position : Vector2, xd = null) -> Vector2:
	if xd == null: #estimating the velocity
		xd = (target_position - xp) / time
		xp = target_position
	
	# to prevent errors from the difference between y and yderivative, we need to clamp k2 over a certain value to make it stable over time
	var k2_stable : float = maxf(k2, 1.1 * ((time*time/4) + (time*k1/2)))
	
	y = y + (time * yd) # integrate position by velocity
	yd = yd + ((time * (target_position + (k3*xd) - y - (k1*yd))) / k2_stable) # integrate position by acceleration
	
	RecalcConstants()
	return y
