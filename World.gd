extends Node3D

# Mesh geometry
var tmpMesh = Mesh.new()
var vertices = PackedVector3Array()
var normals = PackedVector3Array()
var UVs = PackedVector2Array()
var indices = PackedInt32Array() 

# RNG
var rng = RandomNumberGenerator.new()

# granularity of cone
var num_divisions = 20
# height offset fraction \in [0,1] from base to spawn first new branch
var offset_frac0 = 0.3 
# height offset fraction \in [0, 1] from base of one child branch to the next
var offset_frac = 0.1 
# length of branch = branch_len_scale * (p2 - p).len() where p is position of branch base on parent (p1->p2)
var branch_len_scale = 0.7 
# The recursive scaling for the width of a branch
var branch_width_scale = 0.5
# Number of branches
var num_branches = 3
# Max recursion depth
var max_depth = 4

# Initial widths, and lenth
var initial_height = 5.0
var initial_r1 = 2.0
var initial_r2 = 1.0

func draw_tree(p1 : Vector3, p2: Vector3, r1: float, r2: float, depth: int, idx: int):
	if depth == 0:
		return
	var l = (p2 - p1).length()
	var d = p1.direction_to(p2)
	var h1 = d.cross(Vector3.RIGHT)
	var h2 = d.cross(h1)
	var inc = 2 * PI / num_divisions
	for i in range(num_divisions):
		var angle = i * inc
		vertices.push_back(r1 * h1 * cos(angle) + r1 * h2 * sin(angle) + p1)
		vertices.push_back(r2 * h1 * cos(angle) + r2 * h2 * sin(angle) + p2)
		normals.push_back(h1 * cos(angle) + h2 * sin(angle))
		normals.push_back(h1 * cos(angle) + h2 * sin(angle))
		UVs.push_back(Vector2(sin(angle / 4),0))
		UVs.push_back(Vector2(sin(angle / 4),1))
		var idx1b = idx + 2 * i
		var idx1t = idx + 2 * i + 1
		var idx2b = idx + (2 * i + 2) % (2 * num_divisions)
		var idx2t = idx + (2 * i + 3) % (2 * num_divisions)
		indices.append(idx1b)
		indices.append(idx1t)
		indices.append(idx2t)
		indices.append(idx2t)
		indices.append(idx2b)
		indices.append(idx1b)
	var angle_1 = 0 # rng.randf_range(0.0, PI / 2)
	for b in range(num_branches):
		var offset_frac_i = offset_frac0 * (1 + b * offset_frac / num_branches)
		var branch_i1 = p1 * (1 - offset_frac_i) + p2 * offset_frac_i
		var angle = angle_1 + b * (2 * PI) / num_branches
		var dir = h1 * cos(angle) + h2 * sin(angle) + d
		dir = dir.normalized() 
		draw_tree(branch_i1, branch_i1 + dir * branch_len_scale * l, r1 * branch_width_scale, r2 * branch_width_scale, depth - 1, len(vertices))

func generate():
	vertices = PackedVector3Array()
	normals = PackedVector3Array()
	UVs = PackedVector2Array()
	indices = PackedInt32Array() 
	draw_tree(Vector3(0, 0, 0), Vector3(0, initial_height, 0), initial_r1, initial_r2, max_depth, 0)
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = UVs
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices

	var arr_mesh = ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$ProceduralMesh.set_mesh(arr_mesh)

func _input(event):
	if event.is_action_released("gen_random"):
		initial_height = rng.randf_range(5.0, 8.0)
		initial_r1 = rng.randf_range(0.3, 1.0)
		initial_r2 = rng.randf_range(0.0, initial_r1)
		max_depth = rng.randi_range(2, 5)
		generate()

func _ready():
	rng.randomize()
	generate()
	
func _process(_delta):
	pass

func _on_NumBranches_value_changed(value):
	num_branches = value
	generate()

func _on_Depth_value_changed(value):
	max_depth = value
	generate()

func _on_BaseOffset_value_changed(value):
	offset_frac0 = value
	generate()

func _on_BranchSep_value_changed(value):
	offset_frac = value
	generate()

func _on_BranchLengthScale_value_changed(value):
	branch_len_scale = value
	generate()

func _on_BranchWidthScale_value_changed(value):
	branch_width_scale = value
	generate()


func _on_InitialHeight_value_changed(value):
	initial_height = value
	generate()


func _on_IntialBaseWidth_value_changed(value):
	initial_r1 = value
	generate()


func _on_IntialTopWidth_value_changed(value):
	initial_r2 = value
	generate()
