extends KinematicBody2D

var speed = 64


func _physics_process(delta):
	var velocity = Vector2.ZERO
	var dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = dir * speed
	move_and_slide(velocity)
