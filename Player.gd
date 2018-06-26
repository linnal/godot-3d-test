extends KinematicBody

var direction = Vector3()
var velocity = Vector3()
const GRAVITY = -24.8
const MAX_SLOPE_ANGLE = 40
const MAX_SPEED = 10

var MOUSE_SENSITIVITY = 0.05
var rotation_helper
var camera

func _ready():
    rotation_helper = $Rotation_Helper
    camera = $Rotation_Helper/Camera
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
    process_input(delta)
    process_movement(delta)

func process_input(delta):
    direction = Vector3(0, 0, 0)
    var cam_xform = camera.get_global_transform()
    var input_movement_vector = Vector2()

    if Input.is_action_pressed("ui_up"):
        input_movement_vector.y += 1
    if Input.is_action_pressed("ui_down"):
        input_movement_vector.y -= 1
    if Input.is_action_pressed("ui_left"):
        input_movement_vector.x -= 1
    if Input.is_action_pressed("ui_right"):
        input_movement_vector.x = 1

    input_movement_vector = input_movement_vector.normalized()

    direction += -cam_xform.basis.z.normalized() * input_movement_vector.y
    direction += cam_xform.basis.x.normalized() * input_movement_vector.x

func process_movement(delta):
    direction.y = 0
    direction = direction.normalized()

    velocity.y += delta*GRAVITY

    var hvel = velocity
    hvel.y = 0

    var target = direction
    target *= MAX_SPEED

    hvel = hvel.linear_interpolate(target, MAX_SPEED*delta)
    velocity.x = hvel.x
    velocity.z = hvel.z
    velocity = move_and_slide(velocity,Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        rotation_helper.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
        self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

        var camera_rot = rotation_helper.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -70, 70)
        rotation_helper.rotation_degrees = camera_rot


