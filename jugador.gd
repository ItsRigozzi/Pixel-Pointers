extends CharacterBody2D

const SPEED = 300.0

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			$AnimationPlayer.play("caminar_derecha" if direction.x > 0 else "caminar_izquierda")
		else:
			$AnimationPlayer.play("caminar_abajo" if direction.y > 0 else "caminar_arriba")
	else:
		$AnimationPlayer.stop()
		
	move_and_slide()
