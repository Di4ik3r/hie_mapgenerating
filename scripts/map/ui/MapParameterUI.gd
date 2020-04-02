extends MarginContainer

onready var ParameterValue = get_node("MarginContainer/VBoxContainer/CenterContainer2/ParameterValue")


func _on_HSlider_value_changed(value) -> void:
	ParameterValue.text = str(value)
func _on_length_value_changed(value) -> void:
	pass # Replace with function body.
func _on_width_value_changed(value) -> void:
	pass # Replace with function body.
func _on_forest_period_value_changed(value):
	pass # Replace with function body.
