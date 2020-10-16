-- Represents a singular piece of the whole blueprint
minetest.register_node(minetest.get_current_modname()..":blueprint",{
	description = "Blueprint block",
	tiles = {"^[colorize:#802BB1"},
	walkable = false,
	buildable_to = true,
	drop = {},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		minetest.chat_send_all("Rightclicked")
	end
})

-- Used to place down blueprints
minetest.register_node(minetest.get_current_modname()..":blueprint_selector",{
	description = "Blueprint selector",
	tiles = {"^[colorize:#3300FF"},
	walkable = true,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local path = minetest.get_modpath("lazybuilder").."/schematics/House_Simple_1.mts"
		minetest.place_schematic(pos, path, "0",{["wool:red"] = "lazybuilder:blueprint", ["wool:green"] = "lazybuilder:blueprint"} , false)
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		-- TODO
		-- open interface to change the current blueprint and/or to fill the current blueprint with blocks
		minetest.chat_send_all("Rightclicked selector")
	end
})