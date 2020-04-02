extends MarginContainer

signal forest_comparison_chanded(value)
signal forest_percent_chanded(value)
signal forest_period_chanded(value)

func _on_forest_comparison_value_changed(value: float) -> void:
	emit_signal("forest_comparison_chanded", value)
func _on_forest_percent_value_changed(value: float) -> void:
	emit_signal("forest_percent_chanded", value)
func _on_forest_period_value_changed(value: float) -> void:
	emit_signal("forest_period_chanded", value)
