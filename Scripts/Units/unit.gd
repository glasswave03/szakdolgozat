class_name BaseUnit extends Node2D

signal death
signal damaged

@export var health := 10.0:
	set = set_health

func set_health(value):
	if value > health: 
		health = 0
		death.emit()
		return
	
	health = value
	if value < 0:
		damaged.emit()
