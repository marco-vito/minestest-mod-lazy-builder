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

local function get_selector_formspec(pos)
	local formspec = {
		"formspec_version[3]",
		"size[12,12]",
		"list[context;input;4.75,0.96;2,2;]",
		"list[current_player;main;0.5,5;8,4;]",
	}
	local meta = minetest.get_meta(pos)
	local blocks = minetest.deserialize(meta:get_string("blocks"))
	local i = 0
	for k,v in pairs(blocks) do
		table.insert(formspec, "list[context;".. tostring(k) ..";".. tostring(i + 0.5) ..",0.96;2,2;]")
		minetest.chat_send_all(tostring(k))
		i = i + 1
	end
	return table.concat(formspec, "")
end

-- Used to place down blueprints
minetest.register_node(minetest.get_current_modname()..":blueprint_selector",{
	description = "Blueprint selector",
	tiles = {"Builder.png"},
	walkable = true,

	on_construct = function(pos)
		-- Placing schematic and saving it
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

		minetest.place_schematic(pos, schematic, "0",{} , false)
		
		-- preparing the inventory of the placer --
		
		local meta = minetest.get_meta(pos)
		meta:set_string("blocks", minetest.serialize(blocks))
	
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		for k,v in pairs(blocks) do
			inv:set_size(tostring(k), 1)
		end
	
		meta:set_string("formspec", get_selector_formspec(pos))
	end,
	on_receive_fields = function(pos, formname, fields, player)
		if formname == "lazybuilder:selector" then
			print("TEST")
		end
	end
})