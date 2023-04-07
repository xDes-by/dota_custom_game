LinkLuaModifier( "modifire_dota_hero_axe_str8_stack", "heroes/hero_axe/axe_counter_helix_lua/modifire_dota_hero_axe_str8", LUA_MODIFIER_MOTION_NONE )
modifire_dota_hero_axe_str8 = class({})

function modifire_dota_hero_axe_str8:IsHidden() 
    if self:GetStackCount() < 1 then return true end
    return false
end
function modifire_dota_hero_axe_str8:IsDebuff() return true end
function modifire_dota_hero_axe_str8:IsPurgable() return false end
function modifire_dota_hero_axe_str8:IsPermanent() return false end
function modifire_dota_hero_axe_str8:RemoveOnDeath() return true end

function modifire_dota_hero_axe_str8:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifire_dota_hero_axe_str8:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount() * -5
end

function modifire_dota_hero_axe_str8:AddStack( duration )
    if self:GetStackCount() == 6 then return end
    self:SetDuration(duration, true)
	local mod = self:GetParent():AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		"modifire_dota_hero_axe_str8_stack",
		{
			duration = duration,
		}
	)
	mod.modifier = self

	self:IncrementStackCount()
end

function modifire_dota_hero_axe_str8:RemoveStack()
	self:DecrementStackCount()
end

modifire_dota_hero_axe_str8_stack = {}

function modifire_dota_hero_axe_str8_stack:IsHidden()
	return true
end

function modifire_dota_hero_axe_str8_stack:IsPurgable()
	return false
end
function modifire_dota_hero_axe_str8_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifire_dota_hero_axe_str8_stack:OnCreated( kv )
end

function modifire_dota_hero_axe_str8_stack:OnRemoved()
	if IsServer() then
		self.modifier:RemoveStack()
	end
end