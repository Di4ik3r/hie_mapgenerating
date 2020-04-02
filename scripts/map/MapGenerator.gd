class_name MapGenerator
extends Node

export(NodePath) var TerrainPath
export(NodePath) var TreesPath

var Terrain: MultiMeshInstance
var Trees: MultiMeshInstance

export(Resource) var MapVars = preload("res://resources/map/MapVars.tres")

func set_mminstance(_Terrain: MultiMeshInstance, _Trees: MultiMeshInstance) -> void:
	Terrain = _Terrain
	Trees = _Trees
	print(Terrain)
	
func change_parameter(parameter: String, value) -> void:
	MapVars[parameter] = value

func _generate() -> void:
	var forest_blocks = Array()
	var min_height: float = 999.0
	var max_height: float = -999.0
	for a in range(0, MapVars.a_side):
		for b in range(0, MapVars.b_side):
			var noise: float = MapVars.noise.get_noise_2d(a, b) * MapVars.NOISE_MULTIPLIER
			var height: float = MapVars.BLOCK_HEIGHT_MULTIPLIER * MapVars.noise.get_noise_2d(a, b)

			if height > max_height:
				max_height = height

			if height < min_height:
				min_height = height
#
	var full_height: float
	if min_height < 0:
		full_height = max_height + abs(min_height)
	else:
		full_height = max_height

	var instance: int = 0
	for a in range(0, MapVars.a_side):
		for b in range(0, MapVars.b_side):
			var noise: float = MapVars.noise.get_noise_2d(a, b) * MapVars.NOISE_MULTIPLIER
			var height_compare: float = noise + MapVars.HEIGHT_ADDITION
			var height = MapVars.BLOCK_HEIGHT_MULTIPLIER * MapVars.noise.get_noise_2d(a, b)

			if height_compare < MapVars.WATER_COMPARISON:
				height = _generate_water(noise, instance)
			elif height_compare < MapVars.SAND_COMPARISON:
				_generate_sand(noise, instance)
			elif height_compare > 7 - MapVars.MOUNTAIN_COMPARISON && MapVars.generate_mountain:
				height = _generate_mountain(min_height, height, noise, instance)
			elif height_compare > 8 - MapVars.forest_comparison:
				forest_blocks.append(_generate_tree(a, b, min_height, height, noise, instance))
			else:
				_generate_grass(noise, instance)
			_place_block(a, b, min_height, height, noise, instance)
			instance += 1

	var count: int = forest_blocks.size()
	var forest_percent_count = ((count as float * MapVars.forest_percent)) as int
	var array = Array()
	for i in range(count):
		var vector = forest_blocks[i]
		var noise = MapVars.noise_tree.get_noise_2d(vector.x, vector.z) + MapVars.forest_percent * 2 - 0.9
		if noise > 0:
			array.append(vector)

	count = array.size()
	Trees.multimesh.instance_count = count
	for i in range(count):
		var vector = array[i]
		Trees.multimesh.set_instance_color(i, Color(0.2, 0.1, 0))
		Trees.multimesh.set_instance_transform(i, 
			Transform(Basis(), vector))
#	pass

# ########################################################################################### BLOCK GEN
func _generate_water(noise: float, instance: int) -> float:
	var color: Color
	color = Color(MapVars.COLOR_WATER.to_html())
	color = color.linear_interpolate(MapVars.COLOR_WATER_INTERPOLATION,
		Tools.noise_float_lerp(noise) * noise + 1)
	Terrain.multimesh.set_instance_color(instance, color)
	var height = MapVars.WATER_HEIGHT - MapVars.BLOCK_HEIGHT_MULTIPLIER / 1.89
	return height

func _generate_sand(noise: float, instance: int) -> void:
	var color: Color
	color = Color(MapVars.COLOR_SAND.to_html())
	color = color.linear_interpolate(MapVars.COLOR_SAND_INTERPOLATE,
		Tools.noise_float_lerp(noise) + 0.2)
	Terrain.multimesh.set_instance_color(instance, color)

func _generate_mountain(min_height: float, height: float, noise:float, instance: int) -> float:
	var color: Color
	height *= noise * MapVars.MOUNTAIN_COMPARISON / 1.5
	height -= MapVars.BLOCK_HEIGHT_MULTIPLIER / 2
	color = Color(MapVars.COLOR_MOUNTAIN.to_html())
	color = color.linear_interpolate(MapVars.COLOR_MOUNTAIN_INTERPOLATION,
		Tools.noise_float_lerp(noise) * 5 - 10)
	Terrain.multimesh.set_instance_color(instance, color)

	return height

func _generate_tree(a: int, b: int, min_height: float, height: float, noise: float, instance: int) -> Vector3:
	var color: Color
	color = Color(MapVars.COLOR_GRASS.to_html())
	color = color.linear_interpolate(MapVars.COLOR_GRASS_INTERPOLATION,
		Tools.noise_float_lerp(noise))
	Terrain.multimesh.set_instance_color(instance, color)

	var calc: float
	if MapVars.BLOCK_HEIGHT_MULTIPLIER == 0:
		calc = 1
	else:
		calc = (abs(min_height) + height) * MapVars.BLOCK_HEIGHT_MULTIPLIER / (MapVars.BLOCK_HEIGHT_MULTIPLIER / 2) + 1
	var x_offset = rand_range(-0.3, 0.3)
	var z_offset = rand_range(-0.3, 0.3)
	var pos = Vector3(a, calc + 1, b)
#	var pos = Vector3(a + x_offset, calc + 1, b + z_offset)

	return pos

func _generate_grass(noise, instance) -> void:
	var color: Color
	color = Color(MapVars.COLOR_GRASS.to_html())
	color = color.linear_interpolate(MapVars.COLOR_GRASS_INTERPOLATION,
		Tools.noise_float_lerp(noise) )
	Terrain.multimesh.set_instance_color(instance, color)

func _place_block(a: int, b: int, min_height:float, height: float,  noise: float, instance: int) -> void:
	var pos = Vector3(a, (height + abs(min_height) + MapVars.CUBE_SIZE / 2), b)
	var basis = Basis()
	var calc: float
	if MapVars.BLOCK_HEIGHT_MULTIPLIER == 0:
		calc = 1
	else:
		calc = (abs(min_height) + height) * MapVars.BLOCK_HEIGHT_MULTIPLIER / (MapVars.BLOCK_HEIGHT_MULTIPLIER / 2) + 1
	basis = basis.scaled(Vector3(1, calc, 1))
	var transform = Transform(basis, pos)
	Terrain.multimesh.set_instance_transform(instance, transform)

func update_Terrain() -> void:
	seed(MapVars.noise_seed)
	Terrain.multimesh.instance_count = MapVars.a_side * MapVars.b_side
	_generate()
