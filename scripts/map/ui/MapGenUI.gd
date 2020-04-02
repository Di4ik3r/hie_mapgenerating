extends MarginContainer

signal length_changed(value)
signal width_changed(value)
signal seed_changed(value)
signal forest_comparison_changed(value)
signal forest_percent_changed(value)
signal forest_perioad_changed(value)


func _on_length_changed(value: int) -> void:
	emit_signal("length_changed", value)
#	print("length changed to %d" % value)
func _on_width_changed(value: int) -> void:
	emit_signal("width_changed", value)
#	print("width changed to %d" % value)
func _on_seed_changed(value: int) -> void:
	emit_signal("seed_changed", value)
#	print("seed changed to %d" % value)

func _on_forest_comparison_chanded(value: float) -> void:
	emit_signal("forest_comparison_changed", value)
#	print("forest comparison changed to %f" % value)
func _on_forest_percent_chanded(value: float) -> void:
	emit_signal("forest_percent_changed", value)
#	print("forest percent changed to %f" % value)
func _on_forest_period_chanded(value: float) -> void:
	emit_signal("forest_perioad_changed", value)
#	print("forest period changed to %f" % value)
