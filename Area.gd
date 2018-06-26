extends Area

enum DoorState {CLOSE, OPEN, IDLE}
var doorObjLeft
var doorObjRight
var state

func _ready():
    state = DoorState.IDLE
    doorObjLeft = get_node("../DoorLeft")
    doorObjRight = get_node("../DoorRight")

func _process(delta):
    if state == DoorState.OPEN:
        openDoor(doorObjLeft, 80, delta*2)
        openDoor(doorObjRight, 180-80, delta*2)
    elif state == DoorState.CLOSE:
        closeDoor(doorObjLeft, 0, delta*2)
        closeDoor(doorObjRight, 180, delta*2)

func _on_Area_body_entered(body):
     state = DoorState.OPEN

func _on_Area_body_exited(body):
     state = DoorState.CLOSE

func openDoor(door, degree, delta):
    door.rotation = door.rotation.linear_interpolate(
            Vector3(0, deg2rad(degree), 0), delta)

func closeDoor(door, degree, delta):
    door.rotation = door.rotation.linear_interpolate(
            Vector3(0, deg2rad(degree), 0), delta)