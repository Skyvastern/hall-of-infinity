extends ImmediateGeometry

func create_line(points):
	if points == null:
		return
	
	if points.size() == 0:
		return
	
	clear()
	begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	for p in points:
		add_vertex(p)
	
	end()
