#class_name Tools
tool
extends Node

const NOISE_A = -1
const NOISE_B = 1

func _ready():
	pass

func noise_float_lerp(a: float) -> float:
	var result = range_lerp(a * 1, NOISE_A, NOISE_B, 0, 1)
	return result
