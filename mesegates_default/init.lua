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
