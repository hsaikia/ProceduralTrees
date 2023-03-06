extends Camera3D

var cam_dist = 10.0
var cam_theta = 0.0
var cam_phi = 0.0
var cam_target = Vector3(0, 2, 0)
@export var mouse_sensitivity = 0.3
var dragging = false

func set_camera():
	var origin = Vector3(0, 0, cam_dist)
	var up = Vector3(0, 1, 0)
	origin = origin.rotated(Vector3.RIGHT, cam_phi)
	origin = origin.rotated(Vector3.UP, cam_theta)
	up = up.rotated(Vector3.RIGHT, cam_phi)
	up = up.rotated(Vector3.UP, cam_theta)
	look_at_from_position(origin, cam_target, up)

func _input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == MOUSE_BUTTON_WHEEL_UP:
			if event.is_pressed():
				cam_dist += mouse_sensitivity
				set_camera()
				return
		elif event.get_button_index() == MOUSE_BUTTON_WHEEL_DOWN:
			if event.is_pressed():
				cam_dist -= mouse_sensitivity
				set_camera()
				return
		elif event.get_button_index() == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
			else:
				dragging = false
		
	if dragging and event is InputEventMouseMotion:
		cam_theta -= deg_to_rad(event.relative.x * mouse_sensitivity)
		cam_phi -= deg_to_rad(event.relative.y * mouse_sensitivity)
		set_camera()

func _ready():
	set_camera()

