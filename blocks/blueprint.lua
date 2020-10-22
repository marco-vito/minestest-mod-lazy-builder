-- Represents a singular piece of the whole blueprint
minetest.register_node(minetest.get_current_modname()..":blueprint",{
	description = "Blueprint block",
	tiles = {"Blueprint.png"},
	walkable = false,
	drawtype = "glasslike",
	buildable_to = true,
	drop = {},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		minetest.chat_send_all("Rightclicked")
	end
})

-- Used to place down blueprints
minetest.register_node(minetest.get_current_modname()..":blueprint_selector",{
	description = "Blueprint selector",
	tiles = {"Builder.png"},
	walkable = true,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local path = minetest.get_modpath("lazybuilder").."/schematics/House_Simple.mts"
		local schematic  = minetest.read_schematic(path, {})
		local blocks = {}
		for k,v in pairs(schematic.data) do
			if not (v.name == 0 or v.name == "air" or v.name == 254) then
				if blocks[v.name] then
					blocks[v.name] = blocks[v.name] + 1
				else 
					blocks[v.name] = 1
				end
				v.name = "lazybuilder:blueprint"
			end
		end
		for k,v in pairs(blocks) do
			minetest.chat_send_all(tostring("K: " .. tostring(k).. " V: " .. tostring(v)))
		end

		minetest.place_schematic(pos, schematic, "0",{} , false)
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		-- TODO
		-- open interface to change the current blueprint and/or to fill the current blueprint with blocks
		minetest.chat_send_all("Rightclicked selector")
	end
})