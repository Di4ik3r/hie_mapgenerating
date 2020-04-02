extends MarginContainer

signal length_changed(value)
signal width_changed(value)
signal seed_changed(value)


func _on_length_value_changed(value: int) -> void:
	emit_signal("length_changed", value)
func _on_width_value_changed(value: int) -> void:
	emit_signal("width_changed", value)
func _on_seed_value_changed(value: int) -> void:
	emit_signal("seed_changed", value)
