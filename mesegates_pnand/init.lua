mesegates:register_gate({
	mod = "mesegates_pnand",
	name = "pnand",	description = "P-NAND Gate",
	min_inputs = 3, max_inputs = 3,
	on_change = function(pos, node)
		local count_on = mesegates:get_powered_input_count(pos, node)
		for _, rule in ipairs(mesegates:get_input_rules(node)) do
			local rule_node = minetest.get_node({x = pos.x+rule.x, y = pos.y+rule.y, z = pos.z+rule.z})
			local rule_node_def = minetest.registered_nodes[rule_node.name]
			if rule_node_def ~= nil and rule_node_def["groups"] ~= nil and rule_node_def.groups["pnand_energy_source"] ~= nil then count_on = count_on + 1 end
		end
		mesegates:set_state(pos, (count_on == 1) or (count_on == 2))
	end
})

-- Modify meseblock

local rules = {{x = -1, z = 0}, {x = 1, z = 0}, {x = 0, z = -1}, {x = 0, z = 1}}
local pnand_update = function(pos)
	for _, rule in ipairs(rules) do
		local pos2 = {x = pos.x+rule.x, y = pos.y, z = pos.z+rule.z}
		local node = minetest.get_node(pos2)
		if string.find(node.name, "mesegates:pnand") ~= nil then
			minetest.registered_nodes[node.name].mesecons.effector.action_change(pos2, node)
		end
	end
end

minetest.register_node(":default:mese", {
	description = "Mese Block",
	tiles = {"default_mese_block.png"},
	is_ground_content = true,
	groups = {cracky=1,level=2,pnand_energy_source=1},
	sounds = default.node_sound_stone_defaults(),
	light_source = 6,
	after_place_node = pnand_update,
	after_dig_node = pnand_update
});

-- Fix piston movement for mese

mesecon:register_on_mvps_move(function(moved_nodes)
	for _, n in ipairs(moved_nodes) do
		if n.node ~= nil and string.find(n.node.name, "default:mese") ~= nil then
			pnand_update(n.pos)
			pnand_update(n.oldpos)
		end
	end
end)
