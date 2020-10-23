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

-- builds the UI dynamically depending on the amount of different blocks in the schematic
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

-- returns a table containing the blocks in a schematic
-- key: name of the block e.g. "default:dirt"
-- value: count of the block
-- the blocks "air" and other blocks that are used for background work are ignored
local function get_blocks_from_schematic(schematic)
	local blocks = {}
	for k,v in pairs(schematic.data) do
		if not (v.name == 0 or v.name == "air" or v.name == 254) then
			if blocks[v.name] then
				blocks[v.name] = blocks[v.name] + 1
			else 
				blocks[v.name] = 1
			end
		end
	end
	return blocks
end

-- replaces all the blocks in a schematic with the given 'block' parameter
local function replace_blocks_in_schematic(schematic, block)
	for k,v in pairs(schematic.data) do
		if not (v.name == 0 or v.name == "air" or v.name == 254) then
			v.name = block
		end
	end
end

-- Used to place down blueprints
minetest.register_node(minetest.get_current_modname()..":blueprint_selector",{
	description = "Blueprint selector",
	tiles = {"Builder.png"},
	walkable = true,

	on_construct = function(pos)
		local path = minetest.get_modpath("lazybuilder").."/schematics/House_Simple.mts"
		local schematic  = minetest.read_schematic(path, {})
		local blocks = get_blocks_from_schematic(schematic)
		replace_blocks_in_schematic(schematic, "lazybuilder:blueprint")
		minetest.place_schematic(pos, schematic, "0",{} , false)
		

		-- to allow access in the formspec we need to save the blocks information in the metadata
		local meta = minetest.get_meta(pos)
		meta:set_string("blocks", minetest.serialize(blocks)) 
	
		-- preparing the inventory of the placer --
		local inv = meta:get_inventory()
		for k,v in pairs(blocks) do -- Create an inventory for each different item in blocks
			inv:set_size(tostring(k), 1)
		end
	
		meta:set_string("formspec", get_selector_formspec(pos))
	end,
	on_receive_fields = function(pos, formname, fields, player)
		
	end
})