tool
extends Spatial


export(int, 1, 100) var a_side: int = 100 setget _set_a
export(int, 1, 100) var b_side: int = 70 setget _set_b
export(int) var noise_seed: int = 0 setget _set_noise_seed
export(int, 0, 40, 1) var noise_multiplier = 6 setget _set_noise_multiplier
export(float, 0, 1, 0.01) var noise_persistance = 0.25 setget _set_noise_persistance
export(int, 0, 30, 1) var noise_octaves = 2 setget _set_noise_octaves
export(float, 0, 10, 0.1) var noise_lactunarity = 2 setget _set_noise_lactunarity
export(float, -1, 5, 0.001) var height_addition = 2.8 setget _set_height_addition
export(float, -1, 1, 0.001) var sand_comparison = 0.2 setget _set_sand_comparison
export(float, 0, 8, 0.001) var forest_comparison = 4 setget _set_forest_comparison
export(float, 0, 1, 0.01) var forest_percent = 0.3 setget _set_forest_percent
export(int, 1, 40, 1) var forest_period = 7 setget _set_forest_period

export(Color) var color_grass_interpolate: Color = Color(0, 0.7, 0) setget _set_color_grass_interpolate
export(Color) var color_grass: Color = Color(0.1, 0.8, 0) setget _set_color_grass
export(Color) var color_sand_interpolate: Color = Color.black setget _set_color_sand_interpolate
export(Color) var color_sand: Color = Color(0.6, 0.4, 0) setget _set_color_sand
export(Color) var color_water_interpolate := Color(0, 0.5, 1) setget _set_color_water_interpolate
export(Color) var color_water := Color.blue setget _set_color_water

export(float, -2, -0.5, 0.001) var water_height := -0.8 setget _set_water_height
export(float, -1, 1, 0.001) var water_comparison = -0.4 setget _set_water_comparison

var forest_blocks: = Array()

var _noise: = OpenSimplexNoise.new()
var _noise_tree: = OpenSimplexNoise.new()

onready var Terrain := $Terrain as MultiMeshInstance
onready var Trees := $"Terrain/Trees" as MultiMeshInstance
onready var SceneCamera := $Camera as Camera
onready var SceneLight := $DirectionalLight as DirectionalLight


func _init():
	_terrain_noise_configuration()
	_trees_noise_configuration()
	if Engine.editor_hint:
		Terrain = get_child(0)
		if Terrain:
			Trees = get_child(0).get_child(0)

func _ready() -> void:
	_init()
	_update_Terrain()

func _process(delta: float) -> void:
	if not Engine.editor_hint:
		SceneLight.rotate_x(delta)

func generate() -> void:
	forest_blocks = Array()
	
	var instance: int = 0
	for a in range(0, a_side):
		for b in range(0, b_side):
			var noise = _noise.get_noise_2d(a, b) * noise_multiplier
			var height = noise + height_addition
			
			if height < water_comparison:
				var color = Color(color_water.to_html())
				color = color.linear_interpolate(color_water_interpolate,
					Tools.noise_float_lerp(noise) * noise + 1)
				Terrain.multimesh.set_instance_color(instance, color)
				height = water_height
			elif height < sand_comparison:
				var color = Color(color_sand.to_html())
				color = color.linear_interpolate(color_sand_interpolate,
					Tools.noise_float_lerp(noise) + 0.2)
				Terrain.multimesh.set_instance_color(instance, color)
			elif height > 8 - forest_comparison:
				var color: Color = Color(color_grass.to_html())
				color = color.linear_interpolate(color_grass_interpolate,
					Tools.noise_float_lerp(noise))
				Terrain.multimesh.set_instance_color(instance, color)
				
#				Terrain.multimesh.set_instance_color(instance, Color.lime)
				
				forest_blocks.append(Vector3(a, height + 0.5, b))
#				if rand() < forest_percent:
#					Trees
			else:
				var color: Color = Color(color_grass.to_html())
				color = color.linear_interpolate(color_grass_interpolate,
					Tools.noise_float_lerp(noise) )
				Terrain.multimesh.set_instance_color(instance, color)
				
			var pos = Vector3(a, height - 1, b)
#			var pos = Vector3(a, 0, b)
#			var basis = Basis()
#			basis = basis.scaled(Vector3(1, height, 1))
			Terrain.multimesh.set_instance_transform(instance, 
				Transform(Basis(), pos))
#				Transform(basis, pos))
			
#			Terrain.multimesh.set_instance_color(instance, Color(noise, noise, noise))
			instance += 1
	
	var count = forest_blocks.size()
	var forest_percent_count = ((count as float * forest_percent)) as int
	var array = Array()
	for i in range(count):
		var vector = forest_blocks[i]
		var noise = _noise_tree.get_noise_2d(vector.x, vector.z) + forest_percent * 2 - 0.9
		if noise > 0:
			array.append(vector)
			
	count = array.size()
	Trees.multimesh.instance_count = count
	for i in range(count):
		var vector = array[i]
		Trees.multimesh.set_instance_color(i, Color(0.2, 0.1, 0))
		Trees.multimesh.set_instance_transform(i, 
			Transform(Basis(), vector))


func _update_Terrain() -> void:
	if not Terrain:
		if get_child_count() > 0:
			_init()
		return
	
#	randomize()
	seed(noise_seed)
	Terrain.multimesh.instance_count = a_side * b_side
	generate()

func _set_a(value: int) -> void:
	a_side = value
	_update_Terrain()
	
func _set_b(value: int) -> void:
	b_side = value
	_update_Terrain()

func _set_noise_seed(value: int) -> void:
	_noise.seed = value
	_noise_tree.seed = value
	noise_seed = value
	_update_Terrain()

func _set_noise_multiplier(value: int) -> void:
	noise_multiplier = value
	_update_Terrain()

func _set_height_addition(value: float) -> void:
	height_addition = value
	_update_Terrain()

func _set_water_comparison(value: float) -> void:
	water_comparison = value
	_update_Terrain()

func _set_sand_comparison(value: float) -> void:
	sand_comparison = value
	_update_Terrain()

func _set_color_grass(value: Color) -> void:
	color_grass = value
	_update_Terrain()

func _set_color_sand(value: Color) -> void:
	color_sand = value
	_update_Terrain()

func _set_color_water(value: Color) -> void:
	color_water = value
	_update_Terrain()

func _set_water_height(value: float) -> void:
	water_height = value
	_update_Terrain()

func _set_noise_persistance(value: float) -> void:
	noise_persistance = value
	_terrain_noise_configuration()
	_update_Terrain()

func _set_noise_octaves(value: int) -> void:
	noise_octaves = value
	_terrain_noise_configuration()
	_update_Terrain()

func _set_color_grass_interpolate(value: Color) -> void:
	color_grass_interpolate = value
	_update_Terrain()

func _set_color_sand_interpolate(value: Color) -> void:
	color_sand_interpolate = value
	_update_Terrain()

func _set_noise_lactunarity(value: float) -> void:
	noise_lactunarity = value
	_update_Terrain()

func _set_color_water_interpolate(value: Color) -> void:
	color_water_interpolate = value
	_update_Terrain()

func _set_forest_comparison(value: float) -> void:
	forest_comparison = value
	_update_Terrain()

func _set_forest_percent(value: float) -> void:
	forest_percent = value
	_update_Terrain()

func _set_forest_period(value: int) -> void:
	forest_period = value
	_trees_noise_configuration()
	_update_Terrain()

func _terrain_noise_configuration() -> void:
	_noise.seed = noise_seed if noise_seed else 0
	_noise.octaves = noise_octaves
	_noise.period = 32
	_noise.persistence = noise_persistance
	_noise.lacunarity = noise_lactunarity

func _trees_noise_configuration() -> void:
	_noise_tree.seed = noise_seed if noise_seed else 0
	_noise_tree.octaves = 2
	_noise_tree.period = forest_period
	_noise_tree.persistence = 0
	_noise_tree.lacunarity = 2
