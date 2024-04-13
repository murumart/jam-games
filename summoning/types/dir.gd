class_name Dir


static func dir_contents(path: String) -> Array:
	var files := []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				files.append_array(dir_contents(path + file_name))
			else:
				files.append(str(path, "/", file_name))
			file_name = dir.get_next()
	else:
		printerr("An error occurred when trying to access the path.")
		printerr(error_string(DirAccess.get_open_error()))
	return files


static func load_demon_parts() -> Dictionary:
	var parts := {}
	const path = "res://scenes/demon_parts/"
	var dir := DirAccess.open(path)
	if not dir:
		printerr("jama! ", error_string(DirAccess.get_open_error()))
		return {}
	dir.list_dir_begin()
	var filename := dir.get_next()
	while filename != "":
		if dir.current_is_dir():
			var m := dir_contents(str(path, filename)).map(func(a): return (a as String).replace(".remap", ""))
			var n := {}
			for a in m:
				var fn := a as String
				var dc := {}
				dc[&"scene"] = load(fn)
				for stat: StringName in DemonStats.STATS.keys():
					var where := fn.find(stat)
					if where != -1:
						dc[stat] = int(fn.substr(where))
				n[fn.trim_prefix(path)] = dc
			parts[StringName(filename)] = n
		filename = dir.get_next()
	return parts

