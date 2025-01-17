rn.item =
{
	id = 0,
	name = "Unknown",
	slot_id = nil,
	texture_name = nil,
	-- we can't use a table here i.e `texture_tint = {1, 1, 1}` coz tables are pass by reference, meaning they all reference the same thing.
	-- might be a way to do it properly, but separate members for the components works fine.
	texture_tint_r = 1,
	texture_tint_g = 1,
	texture_tint_b = 1,
	equipment_buff = nil,
	rarity = "common"
}
rn.items = {}

rn.rarity_get_colour = function(rarity)
	if rarity == "common" then return 0.57735, 0.57735, 0.57735 end
	if rarity == "uncommon" then return 0.331295, 0.883452, 0.331295 end
	if rarity == "rare" then return 0.251498, 0.402396, 0.880242 end
	if rarity == "epic" then return 0.699127, 0.149813, 0.699127 end
	if rarity == "legendary" then return 0.991228, 0.0, 0.132164 end
	return 0.0, 0.0, 0.0
end

function rn.item:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function rn.item:get_id()
	return self.id
end

function rn.item:set_id(id)
	self.id = id
end

function rn.item:get_name()
	return self.name
end

function rn.item:set_name(name)
	self.name = name
end

function rn.item:get_equipment_slot_id()
	return self.slot_id
end

function rn.item:set_equipment_slot_id(id)
	self.slot_id = id
end

function rn.item:get_texture_name()
	return self.texture_name
end

function rn.item:set_texture_name(name)
	self.texture_name = name
end

function rn.item:get_texture_tint()
	return self.texture_tint_r, self.texture_tint_g, self.texture_tint_b
end

function rn.item:set_texture_tint(r, g, b)
	self.texture_tint_r = r
	self.texture_tint_g = g
	self.texture_tint_b = b
end

function rn.item:set_buff(buff)
	self.equipment_buff = buff
end

function rn.item:get_buff()
	return self.equipment_buff
end

function rn.item:get_rarity()
	return self.rarity
end

function rn.item:set_rarity(rarity)
	self.rarity = rarity
end

rn.items = {}

require "item0"
require "item1"
require "item2"
require "item3"
require "item4"
require "item5"
require "item6"
require "item7"
require "item8"

rn.drop_item_at = function(item_name, x, y)
	local mannequin_id = 3
	local eid = rn.scene():add(mannequin_id)
	local ent = rn.scene():get(eid)
	rn.equip(ent, item_name)
	ent:get_element():set_position(x, y)
end

rn.drop_items_at = function(x, y, ...)
	local mannequin_id = 3
	local eid = rn.scene():add(mannequin_id)
	local ent = rn.scene():get(eid)
	for i, v in ipairs({...}) do
		rn.equip(ent, v)
	end
	ent:get_element():set_position(x, y)
end

rn.item_static_init = function()
	for k, cur_item in pairs(rn.items) do
		-- item static init
		local path = cur_item:get_texture_name()
		local name = cur_item:get_name()
		tz.assert(path ~= nil)
		print(path)
		rn.texture_manager():register_texture(name .. ".texture", path)
	end
end