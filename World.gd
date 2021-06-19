extends Spatial
var tmpMesh = Mesh.new()
var vertices = PoolVector3Array()
var UVs = PoolVector2Array()
var mat = SpatialMaterial.new()
var color = Color(1.0, 1.0, 1.0)
var num_divisions = 10

func draw_cone(r1, r2, l):
	var inc = 2 * PI / num_divisions
	for i in range(num_divisions):
		var angle1 = i * inc
		var angle2 = ((i + 1) % num_divisions) * inc
		vertices.push_back(Vector3(r1 * cos(angle1), 0, r1 * sin(angle1)))
		vertices.push_back(Vector3(r1 * cos(angle2), 0, r1 * sin(angle2)))
		vertices.push_back(Vector3(r2 * cos(angle2), l, r2 * sin(angle2)))
		vertices.push_back(Vector3(r2 * cos(angle1), l, r2 * sin(angle1)))
		UVs.push_back(Vector2(0,0))
		UVs.push_back(Vector2(0,1))
		UVs.push_back(Vector2(1,1))
		UVs.push_back(Vector2(1,0))
	

func _ready():
	draw_cone(2.0, 1.0, 5.0)
#	vertices.push_back(Vector3(1,0,0))
#	vertices.push_back(Vector3(1,0,1))
#	vertices.push_back(Vector3(0,0,1))
#	vertices.push_back(Vector3(0,0,0))

#	UVs.push_back(Vector2(0,0))
#	UVs.push_back(Vector2(0,1))
#	UVs.push_back(Vector2(1,1))
#	UVs.push_back(Vector2(1,0))

	mat.albedo_color = color

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
	st.set_material(mat)

	for v in vertices.size(): 
		st.add_color(color)
		st.add_uv(UVs[v])
		st.add_vertex(vertices[v])

	st.commit(tmpMesh)

	$MeshInstance.mesh = tmpMesh

