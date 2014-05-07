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
mesegates:register_gate({
	mod = "mesegates_default",
	name = "rs_flipflop", description = "RS Flip-Flop",
	min_inputs = 2, max_inputs = 3,
	possible_sides = {5, 7}, default_side = 5,
	on_on = function(pos, node)
		local c = true
		if mesegates:get_side_id(pos) == 7 then
			c = mesegates:is_powered(pos, node, {x = 1, y = 0, z = 0})
		end
		if c then
			local r = mesegates:is_powered(pos, node, {x = 0, y = 0, z = -1})
			local s = mesegates:is_powered(pos, node, {x = 0, y = 0, z = 1})
			if r and (not s) then
				mesegates:set_state(pos, false)
			elseif s and (not r) then
				mesegates:set_state(pos, true)
			end
		end
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "t_flipflop", description = "Toggle Flip-Flop",
	min_inputs = 2, max_inputs = 2,
	possible_sides = {3, 6}, default_side = 6,
	on_change = function(pos, node)
		if mesegates:is_powered(pos, node, {x = 1, y = 0, z = 0}) then
			local toggle = (mesegates:get_powered_input_count(pos, node)) > 1
			local current = mesegates:get_state(pos)
			mesegates:set_state(pos, toggle == not current)
		end
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "d_flipflop", description = "D Flip-Flop",
	min_inputs = 2, max_inputs = 3,
	possible_sides = {3, 6, 7}, default_side = 7,
	on_change = function(pos, node)
		if mesegates:is_powered(pos, node, {x = 1, y = 0, z = 0}) then
			local d = (mesegates:get_powered_input_count(pos, node)) > 1
			mesegates:set_state(pos, d)
		end
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "jk_flipflop", description = "JK Flip-Flop",
	min_inputs = 3, max_inputs = 3,
	on_change = function(pos, node)
		if mesegates:is_powered(pos, node, {x = 1, y = 0, z = 0}) then
			local j = mesegates:is_powered(pos, node, {x = 0, y = 0, z = -1})
			local k = mesegates:is_powered(pos, node, {x = 0, y = 0, z = 1})
			if j and (not k) then
				mesegates:set_state(pos, false)
			elseif k and (not j) then
				mesegates:set_state(pos, true)
			elseif j and k then
				mesegates:set_state(pos, not mesegates:get_state(pos))
			end
		end
	end
})
mesegates:register_gate({
	mod = "mesegates_default",
	name = "pulse_former", description = "Pulse Former",
	min_inputs = 1, max_inputs = 1,
	on_on = function(pos, node)
		mesegates:set_state(pos, true)
		minetest.after(mesegates:get_refresh_time() * 3, function(pos)
			mesegates:set_state(pos, false)
		end, pos)
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

add_opposites("and")
add_opposites("or")
add_opposites("xor")

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

minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:t_latch"),
	recipe = {
		{mesegates:get_creative_name("mesegates_default:nand")},
		{mesegates:get_creative_name("mesegates_default:not")},
		{"mesegates_default:base"}
	}
})

minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:rs_flipflop"),
	recipe = {
		{mesegates:get_creative_name("mesegates_default:not"), mesegates:get_creative_name("mesegates_default:t_latch"), mesegates:get_creative_name("mesegates_default:diode")}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = mesegates:get_creative_name("mesegates_default:jk_flipflop"),
	recipe = {
		mesegates:get_creative_name("mesegates_default:rs_flipflop"),
		mesegates:get_creative_name("mesegates_default:t_latch")
	}
})

minetest.register_craft({
	output = mesegates:get_creative_name("mesegates_default:d_flipflop"),
	recipe = {
		{mesegates:get_creative_name("mesegates_default:nand"), mesegates:get_creative_name("mesegates_default:not")},
		{mesegates:get_creative_name("mesegates_default:not"), mesegates:get_creative_name("mesegates_default:nand")}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = mesegates:get_creative_name("mesegates_default:t_flipflop"),
	recipe = {
		mesegates:get_creative_name("mesegates_default:t_latch"),
		mesegates:get_creative_name("mesegates_default:nand")
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "mesegates_default:base 9",
	recipe = {"default:stone", "default:mese_crystal"}
})
