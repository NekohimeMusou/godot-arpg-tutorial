extends CharacterBody2D

signal healthChanged

@export var speed: int = 80
@onready var animations = $AnimationPlayer
#@onready var hurtColor = $Sprite2D/ColorRect

@export var maxHealth = 3
@onready var currentHealth: int = maxHealth

@export var knockbackPower = 500

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	
func updateAnimation():
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"

		animations.play("walk" + direction)

func _physics_process(_delta):
	handleInput()
	move_and_slide()
	updateAnimation()


func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = maxHealth

		healthChanged.emit(currentHealth)
		knockback(area.get_parent().velocity)

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = -(enemyVelocity + velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
