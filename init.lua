intersect_light = {}
intersect_light.version = "1.0"

intersect_light.path = minetest.get_modpath("intersect_light")


function table.copy(orig)
	local orig_type = type(orig)
	local copy_t
	if orig_type == 'table' then
		copy_t = {}
		for orig_key, orig_value in next, orig, nil do
			copy_t[table.copy(orig_key)] = table.copy(orig_value)
		end
		setmetatable(copy_t, table.copy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy_t = orig
	end
	return copy_t
end


dofile(intersect_light.path .. "/nodes.lua")
dofile(intersect_light.path .. "/mapgen.lua")

minetest.register_on_generated(intersect_light.generate)

