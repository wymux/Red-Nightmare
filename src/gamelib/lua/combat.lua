rn.combat = {}
rn.entity_damage_entity_event = 
{
	tag = "entity_damage_entity",
	damager = nil,
	damagee = nil,
	value = 0,
	damage_type = "Physical"
}

function rn.entity_damage_entity_event:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

rn.entity_heal_entity_event = 
{
	tag = "entity_heal_entity",
	healer = nil,
	healee = nil,
	value = 0,
}

function rn.entity_heal_entity_event:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function rn.combat.base_on_death(ent, evt)
	-- call on_death if it exists
	local handler = rn.entity_handler[ent:get_type()]
	if handler.on_death ~= nil then
		local success = handler.on_death(ent, evt)
		if success ~= nil and not success then return end
	end
	rn.unequip_and_drop_all(ent)
	ent:get_element():play_animation(7, false)
end

-- ent was hit by a entity_damage_entity_event
function rn.combat.base_on_struck(ent, evt)
	local hp = ent:get_health()
	local new_hp = ent:get_health() - evt.value

	-- call on_struck if it exists
	local handler = rn.entity_handler[ent:get_type()]
	if handler.on_struck ~= nil then
		local success = handler.on_struck(ent, evt)
		if success ~= nil and not success then return end
	end

	if new_hp <= 0 then
		new_hp = 0
		if not ent:is_dead() then
			rn.combat.base_on_death(ent, evt)
		end
	end
	tz.assert(handler ~= nil)
	ent:set_health(new_hp)
end

-- ent was affected by a entity_heal_entity_event
function rn.combat.base_on_healed(ent, evt)
	local hp = ent:get_health()
	local max = ent:get_stats():get_maximum_health()
	local hpdiff = max - (hp + evt.value)
	if hpdiff < 0 then
		evt.value = evt.value + hpdiff
	end
	local new_hp = hp + evt.value
	-- call on_healed if it exists
	local handler = rn.entity_handler[ent:get_type()]
	if handler.on_healed ~= nil then
		local success = handler.on_healed(ent, evt)
		if success ~= nil and not success then return end
	end
	ent:set_health(new_hp)
end

function rn.combat.base_on_hit(ent, evt)
	-- call on_hit if it exists
	local handler = rn.entity_handler[ent:get_type()]
	if handler.on_hit ~= nil then
		local success = handler.on_hit(ent, evt)
		if success ~= nil and not success then return end
	end
end

function rn.combat.base_on_heal(ent, evt)
	-- call on_heal if it exists
	local handler = rn.entity_handler[ent:get_type()]
	if handler.on_heal ~= nil then
		local success = handler.on_heal(ent, evt)
		if success ~= nil and not success then return end
	end
end

function rn.combat.process_event(evt)
	tz.assert(evt ~= nil)
	tz.assert(evt.tag ~= nil)
	if evt.tag == "entity_damage_entity" then
		local damager = rn.scene():get_uid(evt.damager)
		local damagee = rn.scene():get_uid(evt.damagee)
		rn.combat.base_on_struck(damagee, evt)
		rn.combat.base_on_hit(damager, evt)
		print(damager:get_name() .. " hurts " .. damagee:get_name() .. " for " .. evt.value .. " damage.")
	end
	if evt.tag == "entity_heal_entity" then
		local healer = rn.scene():get_uid(evt.healer)
		local healee = rn.scene():get_uid(evt.healee)
		rn.combat.base_on_healed(healee, evt)
		rn.combat.base_on_heal(healer, evt)
		print(healer:get_name() .. " heals " .. healee:get_name() .. " for " .. evt.value)
	end
end