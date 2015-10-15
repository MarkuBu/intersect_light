function intersect_light.clone_node(name)
	local node = minetest.registered_nodes[name]
	local node2 = table.copy(node)
	return node2
end


if vmg and vmg.branch == "c" then
	minetest.register_alias("intersect_light:glowing_fungal_stone", "valleys_c:glowing_fungal_stone")
	minetest.register_alias("intersect_light:glowing_fungus", "valleys_c:glowing_fungus")
	minetest.register_alias("intersect_light:moon_juice", "valleys_c:moon_juice")
	minetest.register_alias("intersect_light:moon_glass", "valleys_c:moon_glass")
else
	minetest.register_node("intersect_light:glowing_fungal_stone", {
		description = "Glowing Fungal Stone",
		tiles = {"default_stone.png^vmg_glowing_fungal.png",},
		is_ground_content = true,
		light_source = 8,
		groups = {cracky=3, stone=1},
		drop = {items={ {items={"default:cobble"},}, {items={"intersect_light:glowing_fungus",},},},},
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_node("intersect_light:glowing_fungus", {
		description = "Glowing Fungus",
		inventory_image = "vmg_glowing_fungus.png",
	})

	-- The fungus can be made into juice and then into glowing glass.
	minetest.register_node("intersect_light:moon_juice", {
		description = "Moon Juice",
		inventory_image = "vmg_moon_juice.png",
	})

	minetest.register_node("intersect_light:moon_glass", {
		description = "Moon Glass",
		drawtype = "glasslike",
		tiles = {"default_glass.png",},
		is_ground_content = true,
		light_source = 14,
		groups = {cracky=3},
		sounds = default.node_sound_glass_defaults(),
	})

	minetest.register_craft({
		output = "intersect_light:moon_juice",
		recipe = {
			{"intersect_light:glowing_fungus", "intersect_light:glowing_fungus", "intersect_light:glowing_fungus"},
			{"intersect_light:glowing_fungus", "intersect_light:glowing_fungus", "intersect_light:glowing_fungus"},
			{"intersect_light:glowing_fungus", "vessels:glass_bottle", "intersect_light:glowing_fungus"},
		},
	})

	minetest.register_craft({
		output = "intersect_light:moon_glass",
		recipe = {
			{"", "intersect_light:moon_juice", ""},
			{"", "intersect_light:moon_juice", ""},
			{"", "default:glass", ""},
		},
	})
end

