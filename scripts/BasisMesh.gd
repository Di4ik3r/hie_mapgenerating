tool
extends MeshInstance

const cube_size = 1
export(float, 0.1, 10, 0.1) var y_scale = 1 setget _set_y_scale

func build() -> void:
	scale = Vector3(1, y_scale, 1)
#	translation = Vector3(0, (cube_size as float - cube_size as float / 2) * y_scale, 0)
	translation = Vector3(0, 0, 0)
	
	print("%f : %s" % [y_scale, str(translation)])

func _set_y_scale(value: float) -> void:
	y_scale = value
	build()
