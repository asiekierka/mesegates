-- Initialization

mesegates:register_gate({
	mod = "mesegates_default",
	name = "not", description = "NOT Gate",
	min_inputs = 1, max_inputs = 1,
	on_change = function(pos, node)
		local count_on = mesegates:get_powered_input_count(pos, node)
		mesegates:set_state(pos, (count_on == 0))
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "or", description = "OR Gate",
	min_inputs = 2, max_inputs = 3,
	on_change = function(pos, node)
		local count_on = mesegates:get_powered_input_count(pos, node)
		mesegates:set_state(pos, (count_on > 0))
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "and", description = "AND Gate",
	min_inputs = 2, max_inputs = 3,
	on_change = function(pos, node)
		local count_on = mesegates:get_powered_input_count(pos, node)
		mesegates:set_state(pos, (count_on == mesegates:get_input_count(node)))
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "xor", description = "XOR Gate",
	min_inputs = 2, max_inputs = 3,
	on_change = function(pos, node)
		local count_on = mesegates:get_powered_input_count(pos, node)
		mesegates:set_state(pos, (count_on == 1))
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "nxor", description = "XNOR Gate",
	min_inputs = 2, max_inputs = 3,
	on_change = function(pos, node)
		local count_on = mesegates:get_powered_input_count(pos, node)
		mesegates:set_state(pos, (count_on ~= 1))
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "nor", description = "NOR Gate",
	min_inputs = 2, max_inputs = 3,
	on_change = function(pos, node)
		local count_on = mesegates:get_powered_input_count(pos, node)
		mesegates:set_state(pos, (count_on == 0))
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "nand", description = "NAND Gate",
	min_inputs = 2, max_inputs = 3,
	on_change = function(pos, node)
		local count_on = mesegates:get_powered_input_count(pos, node)
		mesegates:set_state(pos, (count_on < mesegates:get_input_count(node)))
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "diode", description = "Diode",
	min_inputs = 1, max_inputs = 1,
	on_change = function(pos, node)
		local count_on = mesegates:get_powered_input_count(pos, node)
		mesegates:set_state(pos, (count_on == 1))
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "t_latch", description = "Toggle Latch",
	min_inputs = 1, max_inputs = 1,
	on_on = function(pos, node)
		local toggle = (mesegates:get_powered_input_count(pos, node) > 0)
		local current = mesegates:get_state(pos)
		mesegates:set_state(pos, toggle == not current)
	end
})

-- Crafting

local add_opposites = function(gate)
	minetest.register_craft({
		type = "shapeless",
		output = mesegates:get_creative_name("mesegates_default:"..gate),
		recipe = {mesegates:get_creative_name("mesegates_default:n"..gate), mesegates:get_creative_name("mesegates_default:not")}
	})
	minetest.register_craft({
		type = "shapeless",
		output = mesegates:get_creative_name("mesegates_default:n"..gate),
		recipe = {mesegates:get_creative_name("mesegates_default:"..gate), mesegates:get_creative_name("mesegates_default:not")}
	})
end

minetest.register_craftitem("mesegates_default:base", {
	description = "Gate Base",
	inventory_image = "mesegates_item_base.png"
})

minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:not"),
	recipe = {
		{"default:mese_crystal_fragment"},
		{"mesegates_default:base"}
	}		
})
minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:diode"),
	recipe = {
		{"mesegates_default:base"},
		{"default:mese_crystal_fragment"}
	}		
})
minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:and").." 2",
	recipe = {
		{"default:mese_crystal_fragment", "", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "mesegates_default:base", "default:mese_crystal_fragment"}
	}
})
minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:or"),
	recipe = {
		{"default:mese_crystal_fragment", "", "default:mese_crystal_fragment"},
		{"", "mesegates_default:base", ""}
	}
})
minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:xor"),
	recipe = {
		{"default:mese_crystal_fragment", "default:mese_crystal_fragment", "default:mese_crystal_fragment"},
		{"", "mesegates_default:base", ""}
	}
})
minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:nand").." 2",
	recipe = {
		{"default:mese_crystal_fragment", "", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "mesegates_default:base", "default:mese_crystal_fragment"},
		{"", mesegates:get_creative_name("mesegates_default:not"), ""}
	}
})
minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:nor"),
	recipe = {
		{"default:mese_crystal_fragment", "", "default:mese_crystal_fragment"},
		{"", "mesegates_default:base", ""},
		{"", mesegates:get_creative_name("mesegates_default:not"), ""}
	}
})
minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:nxor"),
	recipe = {
		{"default:mese_crystal_fragment", "default:mese_crystal_fragment", "default:mese_crystal_fragment"},
		{"", "mesegates_default:base", ""},
		{"", mesegates:get_creative_name("mesegates_default:not"), ""}
	}
})

add_opposites("and")
add_opposites("or")
add_opposites("xor")

minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:t_latch"),
	recipe = {
		{mesegates:get_creative_name("mesegates_default:nand")},
		{mesegates:get_creative_name("mesegates_default:not")},
		{"mesegates_default:base"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "mesegates_default:base 9",
	recipe = {"default:stone", "default:mese_crystal"}
})
