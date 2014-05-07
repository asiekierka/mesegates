mesegates = {}

local creative_names = {}

-- Useful API functions

function mesegates:get_creative_name(gate)
	return creative_names[gate]
end

function mesegates:get_state(pos)
	return (string.byte(minetest.get_node(pos).name, -1) > 48)
end

local get_side_id_from_name = function(name)
	return string.byte(name, -2) - 48
end

local get_param_from_name = function(name)
	return string.byte(name, -3) - 48
end

function mesegates:get_side_id(pos)
	return get_side_id_from_name(minetest.get_node(pos).name)
end

function mesegates:get_param(pos)
	return get_param_from_name(minetest.get_node(pos).name)
end

function mesegates:get_rule(node, rule)
	return mesegates:get_rules(node, {rule})[1]
end

function mesegates:is_powered(pos, node, rule)
	return mesecon:is_powered(pos, mesegates:get_rule(node, rule))
end

function mesegates:get_rules(node, rules)
	if node["param2"] ~= nil then
		for i = 0, node.param2 do
			rules = mesecon:rotate_rules_left(rules)
		end
	end
	return rules
end

local get_output_rules = function(node)
	return mesegates:get_rules(node, {{x = -1, y = 0, z = 0}})
end

local get_input_rules_from_id = function(side_id)
	local inputs = {}
	if side_id >= 4 then table.insert(inputs, {x = 0, y = 0, z = -1}) end
	if (side_id % 4) >= 2 then table.insert(inputs, {x = 1, y = 0, z = 0}) end
	if (side_id % 2) >= 1 then table.insert(inputs, {x = 0, y = 0, z = 1}) end
	return inputs
end

local get_input_rules = function(node)
	local side_id = get_side_id_from_name(node.name)
	return mesegates:get_rules(node, get_input_rules_from_id(side_id))
end

function mesegates:get_output_rules(node)
	return get_output_rules(node)
end

function mesegates:get_input_rules(node)
	return get_input_rules(node)
end

function mesegates:get_input_count(node)
	return #mesecon:effector_get_rules(node)
end

function mesegates:get_powered_input_count(pos, node)
	local count_on = 0
        for _, rule in ipairs(mesegates:get_input_rules(node)) do
                if mesecon:is_powered(pos, rule) then count_on = count_on + 1 end
        end
	return count_on
end

function mesegates:set_state(pos, new_on)
	local current_on = mesegates:get_state(pos)
	local node = minetest.get_node(pos)
	if new_on ~= current_on then
		state_name = "0"
		state_name2 = "off"
		if new_on then
			state_name = "1"
			state_name2 = "on"
		end
		minetest.swap_node(pos, {name = string.sub(node.name, 0, -2)..state_name, param2=node.param2})
		mesecon.queue:add_action(pos, "receptor_"..state_name2, {mesegates:get_output_rules(node)}, 0.05, mesegates:get_output_rules(node))
	end
end

local gate_box = {
	type = "fixed",
	fixed = {-0.5, -0.5, -0.5, 0.5, -0.375, 0.5}
}

local fif = function(condition, if_true, if_false)
	if condition then return if_true else return if_false end
end

function mesegates:register_gate(gate)
	local node_name = gate.mod .. ":" .. gate.name
	local creative_side = 7
	if gate.default_side ~= nil then creative_side = gate.default_side else
		if gate.max_inputs == 2 then creative_side = 5 end
		if gate.max_inputs == 1 then creative_side = 2 end
	end
	local possible_sides = {0,1,2,3,4,5,6,7}
	local max_param = 0
	if gate.max_param ~= nil then max_param = gate.max_param end
	if gate.possible_sides ~= nil then possible_sides = gate.possible_sides end
	for param = 0, max_param do
		for _,sides in ipairs(possible_sides) do
			local side_count = #get_input_rules_from_id(sides)
			if side_count >= gate.min_inputs and side_count <= gate.max_inputs then for on = 0,1 do
				state_name = "off"
				if on == 1 then
					state_name = "on"
				end
				local t_o = "mesegates_side_open.png"
				local t_c = "mesegates_side_closed.png"
				local top_tex = fif((sides % 2) >= 1, "^mesegates_side_open_right.png", "")
					.. fif(sides >= 4, "^mesegates_side_open_left.png", "")
					.. fif((sides % 4) >= 2, "^mesegates_side_open_bottom.png", "")
					.. "^mesegates_"..gate.name.."_"..on..".png"
				if param > 0 then top_tex = top_tex .. "^mesegates_"..gate.name.."_overlay_"..param..".png" end 
				local node = {
					description = gate.description,
					tiles = {"mesegates_top.png"..top_tex, "mesegates_bottom.png",
						fif((sides % 2) >= 1, t_o, t_c),
						fif(sides >= 4, t_o, t_c),
						"mesegates_side_open_top.png",
						fif((sides % 4) >= 2, t_o, t_c)},
					drawtype = "nodebox",
					paramtype = "light", paramtype2 = "facedir",
					node_box = gate_box, selection_box = gate_box,
					is_ground_content = true, groups = {dig_immediate = 2, mesegate = 1},
					sounds = default.node_sound_stone_defaults(),
					mesecons = {
						receptor = { state = state_name, rules = get_output_rules },
						effector = {
							rules = get_input_rules
						}
					},
					drop = node_name.."_0"..creative_side.."0",
					mesegate = gate,
					on_punch = function(pos, node)
						local name_s = string.sub(node.name, 0, -3)
						local name_e = string.sub(node.name, -1)
						local sideo = get_side_id_from_name(node.name)
						for sidep = 1,7 do
							local side = (sideo+sidep) % 8
							local name = name_s .. tostring(side) .. name_e
							if side > 0 and minetest.registered_nodes[name] ~= nil then
								minetest.swap_node(pos, {name=name, param2=node.param2})
								node.name = name
								mesecon:update_autoconnect(pos)
								local effector = minetest.registered_nodes[name].mesecons.effector
								if effector["on_change"] ~= nil then effector.on_change(pos, node) end
							end
						end
					end
				}
				if gate["on_change"] ~= nil then node.mesecons.effector.action_change = gate.on_change end
				if gate["on_on"] ~= nil then node.mesecons.effector.action_on = gate.on_on end
				if gate["on_off"] ~= nil then node.mesecons.effector.action_off = gate.on_off end
				if gate["on_rightclick"] ~= nil then
					node.on_rightclick = gate.on_rightclick
				elseif max_param > 0 then
					node.on_rightclick = function(pos, node)
						local name_s = string.sub(node.name, 0, -4)
						local name_e = string.sub(node.name, -2)
						local name = name_s .. ((get_param_from_name(node.name) + 1) % (max_param + 1)) .. name_e
						minetest.swap_node(pos, {name=name, param2=node.param2})
						node.name = name
						mesecon:update_autoconnect(pos)
						local effector = minetest.registered_nodes[name].mesecons.effector
						if effector["on_change"] ~= nil then effector.on_change(pos, node) end
					end
				end
				if not (on == 0 and sides == creative_side) then
					node.groups.not_in_creative_inventory = 1
				else
					creative_names[node_name] = node_name.."_"..param..sides..on	
				end
				minetest.register_node(node_name.."_"..param..sides..on, node)
			end end
		end
	end
end
