extends Spatial


const CAMERA_HEIGHT = 50

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
	print("%d : %d" % [a, b])
	
	circle_radius = 120
	
	circle_center = Vector3(a / 2, CAMERA_HEIGHT, b / 2)
	CenterPos.translation = circle_center

func _physics_process(delta: float) -> void:
	current_angle += delta
	CameraFollowPos.translation = _circle_equation(current_angle)
	CameraFollowPos.look_at(CenterPos.translation, Vector3.UP)

func _circle_equation(angle: float) -> Vector3:
	var x = circle_center.x + circle_radius * cos(angle)
	var z = circle_center.z + circle_radius * sin(angle)
	return Vector3(x, CAMERA_HEIGHT, z)



#export(Resource) var map_vars: Resource


#export(float, 0, 100, 0.01) var block_height_multiplier: float = 3 setget _set_block_height_multiplier
#export(int, 0, 40, 1) var noise_multiplier: int = 6 setget _set_noise_multiplier

#export(float, 0, 1, 0.01) var noise_persistance = 0.25 setget _set_noise_persistance
#export(int, 0, 30, 1) var noise_octaves = 2 setget _set_noise_octaves
#export(float, 0, 10, 0.1) var noise_lactunarity = 2 setget _set_noise_lactunarity

#export(float, -1, 5, 0.001) var height_addition: float = 2.8 setget _set_height_addition
#export(float, -1, 1, 0.001) var sand_comparison = 0.2 setget _set_sand_comparison



#export(float, 0, 2, 0.001) var mountain_comparison: float = 2 setget _set_mountain_comparison

#export(Color) var color_grass_interpolate: Color = Color(0, 0.7, 0) setget _set_color_grass_interpolate
#export(Color) var color_grass: Color = Color(0.1, 0.8, 0) setget _set_color_grass

#export(Color) var color_grass_interpolate: Color = Color(0.2, 0.6, 0) setget _set_color_grass_interpolate
#export(Color) var color_grass: Color = Color(0.5, 0.8, 0) setget _set_color_grass
#export(Color) var color_sand_interpolate: Color = Color.black setget _set_color_sand_interpolate
#export(Color) var color_sand: Color = Color(0.6, 0.4, 0) setget _set_color_sand
#export(Color) var color_water_interpolate := Color(0, 0.5, 1) setget _set_color_water_interpolate
#export(Color) var color_water := Color.blue setget _set_color_water
#export(Color) var color_mountain_interpolate := Color.white setget _set_color_mountain_interpolate
#export(Color) var color_mountain := Color(0.69, 0.69, 0.69) setget _set_color_mountain

#export(float, -2, 0, 0.001) var water_height: float = -0.2 setget _set_water_height
#export(float, -1, 1, 0.001) var water_comparison: float = -0.4 setget _set_water_comparison

#var forest_blocks: = Array()



#onready var Terrain := $Terrain as MultiMeshInstance
#onready var Trees := $"Terrain/Trees" as MultiMeshInstance


#func _init() -> void:
#	_terrain_noise_configuration()
#	_trees_noise_configuration()
#	if Engine.editor_hint:
#		Terrain = get_child(0) as MultiMeshInstance
#		if Terrain:
#			Trees = Terrain.get_child(0) as MultiMeshInstance

#func _ready() -> void:
#	_init()
#	_update_Terrain()

#func _process(delta: float) -> void:
#	if not Engine.editor_hint:
#		SceneLight.rotate_x(delta)







# ########################################################################################### SETTERS



#func _set_noise_multiplier(value: int) -> void:
#	noise_multiplier = value
#	_update_Terrain()
#func _set_height_addition(value: float) -> void:
#	height_addition = value
#	_update_Terrain()
#func _set_water_comparison(value: float) -> void:
#	water_comparison = value
#	_update_Terrain()
#func _set_sand_comparison(value: float) -> void:
#	sand_comparison = value
#	_update_Terrain()
#func _set_color_grass(value: Color) -> void:
#	color_grass = value
#	_update_Terrain()
#func _set_color_sand(value: Color) -> void:
#	color_sand = value
#	_update_Terrain()
#func _set_color_water(value: Color) -> void:
#	color_water = value
#	_update_Terrain()
#func _set_water_height(value: float) -> void:
#	water_height = value
#	_update_Terrain()
#func _set_noise_persistance(value: float) -> void:
#	noise_persistance = value
#	_terrain_noise_configuration()
#	_update_Terrain()
#func _set_noise_octaves(value: int) -> void:
#	noise_octaves = value
#	_terrain_noise_configuration()
#	_update_Terrain()
#func _set_color_grass_interpolate(value: Color) -> void:
#	color_grass_interpolate = value
#	_update_Terrain()
#func _set_color_sand_interpolate(value: Color) -> void:
#	color_sand_interpolate = value
#	_update_Terrain()
#func _set_noise_lactunarity(value: float) -> void:
#	noise_lactunarity = value
#	_update_Terrain()
#func _set_color_water_interpolate(value: Color) -> void:
#	color_water_interpolate = value
#	_update_Terrain()
#func _set_block_height_multiplier(value: float) -> void:
#	block_height_multiplier = value
#	_update_Terrain()
#func _set_mountain_comparison(value: float) -> void:
#	mountain_comparison = value
#	_update_Terrain()
#func _set_color_mountain(value: Color) -> void:
#	color_mountain = value
#	_update_Terrain()
#func _set_color_mountain_interpolate(value: Color) -> void:
#	color_mountain_interpolate = value
#	_update_Terrain()


func _on_MapGeneratingUI_length_changed(value: int) -> void:
	mapVars.a_side = value
	mapGenerator.update_Terrain()
func _on_MapGeneratingUI_width_changed(value: int) -> void:
	mapVars.b_side = value
	mapGenerator.update_Terrain()
func _on_MapGeneratingUI_seed_changed(value: float) -> void:
	mapVars.noise_seed = value
	mapGenerator.update_Terrain()
func _on_MapGeneratingUI_forest_comparison_changed(value) -> void:
	mapVars.forest_comparison = value
	mapGenerator.update_Terrain()
func _on_MapGeneratingUI_forest_percent_changed(value: float) -> void:
	mapVars.forest_percent = value
	mapGenerator.update_Terrain()
func _on_MapGeneratingUI_forest_perioad_changed(value: float) -> void:
	mapVars.forest_percent = value
	mapGenerator.update_Terrain()
