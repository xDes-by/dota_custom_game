npc_dota_hero_terrorblade_str11 = class({})

function npc_dota_hero_terrorblade_str11:GetIntrinsicModifierName()
	return "modifier_armor_hp"
end

LinkLuaModifier( "modifier_armor_hp", "heroes/hero_terror/armor_hp", LUA_MODIFIER_MOTION_NONE )

modifier_armor_hp = class({})

function modifier_armor_hp:IsHidden()
    return true
end

function modifier_armor_hp:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_armor_hp:OnCreated( kv )
damage = (100 - self:GetCaster():GetHealthPercent())
	self:StartIntervalThink(1)
end

function modifier_armor_hp:OnRefresh( kv )

damage = (100 - self:GetCaster():GetHealthPercent())
end

function modifier_armor_hp:OnIntervalThink()
self:OnRefresh()
end


function modifier_armor_hp:IsPurgable()
	return false
end

function modifier_armor_hp:RemoveOnDeath()
	return false
end

function modifier_armor_hp:GetModifierPhysicalArmorBonus()
	return damage
end