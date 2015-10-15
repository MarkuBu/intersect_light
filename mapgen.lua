function intersect_light.generate(minp, maxp, seed)
	local c_stone = minetest.get_content_id("default:stone")
	local c_fungal_stone = minetest.get_content_id("intersect_light:glowing_fungal_stone")
	local c_water = minetest.get_content_id("default:water_source")
	local c_lava = minetest.get_content_id("default:lava_source")
	local c_glass = minetest.get_content_id("intersect_light:moon_glass")
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local a = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local csize = vector.add(vector.subtract(maxp, minp), 1)

	local write = false

	-- Deal with memory issues. This, of course, is supposed to be automatic.
	local mem = math.floor(collectgarbage("count")/1024)
	if mem > 300 then
		print("Manually collecting garbage...")
		collectgarbage("collect")
	end

	if minp.y < 200 then
		local cave_noise_1 = minetest.get_perlin_map({offset = 0, scale = 1, seed = -8402, spread = {x = 64, y = 64, z = 64}, octaves = 3, persist = 0.5, lacunarity = 2}, csize):get3dMap_flat(minp)
		local cave_noise_2 = minetest.get_perlin_map({offset = 0, scale = 1, seed = 3944, spread = {x = 64, y = 64, z = 64}, octaves = 3, persist = 0.5, lacunarity = 2}, csize):get3dMap_flat(minp)

		local index2d = 0
		local index3d = 0
		for z = minp.z, maxp.z do
			for y = minp.y, maxp.y do
				for x = minp.x, maxp.x do
					index2d = index2d + 1
					index3d = index3d + 1
					local ivm = a:index(x, y, z)

					local n1 = (math.abs(cave_noise_1[index3d]) < 0.07)
					local n2 = (math.abs(cave_noise_2[index3d]) < 0.07)
					if n1 and n2 and data[ivm] ~= c_air and data[ivm] ~= c_water then
						local sr = 1000
						if y > minp.y and data[a:index(x, y-1, z)] == c_stone then
							sr = math.floor((cave_noise_1[index3d] + cave_noise_2[index3d]) * 100000) % 1000
						end

						if y < -200 and sr < math.ceil(-y/10000) then
							data[ivm] = c_lava
						elseif sr < 4 then
							data[ivm] = c_water
						else
							data[ivm] = c_air
						end
						write = true
					end
				end
			end
			index2d = index2d - csize.x
		end
	end

	if write then
		vm:set_data(data)
		vm:set_lighting({day = 0, night = 0})
		vm:calc_lighting()
		vm:update_liquids()
		vm:write_to_map()
	end
end
