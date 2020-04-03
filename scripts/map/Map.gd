extends Spatial


const CAMERA_HEIGHT = 12

var mapGenerator: MapGenerator = MapGenerator.new()
var mapVars: Resource = mapGenerator.MapVars

var circle_center: Vector3 = Vector3.ZERO
var current_angle: float = 0
var circle_radius: float = 1

onready var CameraFollowPos: = $"CameraFollowPos" as Position3D
onready var CenterPos: = $"CenterPos" as Position3D

onready var Terrain = $Terrain
onready var Trees = $Trees

func _ready() -> void:
	mapGenerator.set_mminstance(Terrain, Trees)
	_update()
	mapGenerator.update_Terrain()

func _update() -> void:
	var cube_size = mapVars.CUBE_SIZE
	var a = mapVars.a_side
	var b = mapVars.b_side
	
	var max_side: = max(a, b) as int
	var min_side: = min(a, b) as int
	circle_radius = max_side / 2 + min_side / 2
	
	circle_center = Vector3(a / 2, 10 / 2, b / 2)
	CenterPos.translation = circle_center

func _physics_process(delta: float) -> void:
	current_angle += delta / 10
	CameraFollowPos.translation = _circle_equation(current_angle)
	CameraFollowPos.look_at(CenterPos.translation, Vector3.UP)
	CenterPos.look_at(CameraFollowPos.translation, Vector3.UP)

func _circle_equation(angle: float) -> Vector3:
	var x = circle_center.x + circle_radius * cos(angle)
	var z = circle_center.z + circle_radius * sin(angle)
	return Vector3(x, CAMERA_HEIGHT, z)




func _on_MapGeneratingUI_length_changed(value: int) -> void:
	mapVars.a_side = value
	mapGenerator.update_Terrain(true)
	_update()
func _on_MapGeneratingUI_width_changed(value: int) -> void:
	mapVars.b_side = value
	mapGenerator.update_Terrain(true)
	_update()
func _on_MapGeneratingUI_seed_changed(value: float) -> void:
	mapVars.noise_seed = value
	mapGenerator.update_Terrain(true)
func _on_MapGeneratingUI_forest_comparison_changed(value) -> void:
	mapVars.forest_comparison = value
	mapGenerator.update_Terrain()
func _on_MapGeneratingUI_forest_percent_changed(value: float) -> void:
	mapVars.forest_percent = value
	mapGenerator.update_Terrain()
func _on_MapGeneratingUI_forest_perioad_changed(value: float) -> void:
	mapVars.forest_percent = value
	mapGenerator.update_Terrain()
