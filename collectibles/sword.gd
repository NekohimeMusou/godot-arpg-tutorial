extends "res://collectibles/baseCollectible.gd"

@onready var animations = $AnimationPlayer

func collect(inventory: Inventory):
	animations.play("spin")
	await animations.animation_finished
	super(inventory)
