npc_dota_hero_terrorblade_str9 = class({})

function npc_dota_hero_terrorblade_str9:GetIntrinsicModifierName()
	return "modifier_hp_dmg"
end

LinkLuaModifier( "modifier_hp_dmg", "heroes/hero_terror/hp_dmg", LUA_MODIFIER_MOTION_NONE )

modifier_hp_dmg = class({})

function modifier_hp_dmg:IsHidden()
    return true
end

function modifier_hp_dmg:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_hp_dmg:OnCreated( kv )
self.damage = self:GetCaster():GetMaxHealth() * 0.02
	self:StartIntervalThink(1)
end

function modifier_hp_dmg:OnRefresh( kv )
self.damage = self:GetCaster():GetMaxHealth() * 0.02
end

function modifier_hp_dmg:OnIntervalThink()
self:OnRefresh()
end


function modifier_hp_dmg:IsPurgable()
	return false
end

function modifier_hp_dmg:RemoveOnDeath()
	return false
end

function modifier_hp_dmg:GetModifierPreAttack_BonusDamage()
	return self.damage
end