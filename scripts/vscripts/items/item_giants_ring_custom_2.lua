LinkLuaModifier("modifier_giants_ring_custom_buff", "items/item_giants_ring_custom/item_giants_ring_custom.lua", LUA_MODIFIER_MOTION_NONE)

item_giants_ring_custom = class({})
item_giants_ring_custom_2 = item_giants_ring_custom
item_giants_ring_custom_3 = item_giants_ring_custom
item_giants_ring_custom_4 = item_giants_ring_custom
item_giants_ring_custom_5 = item_giants_ring_custom
item_giants_ring_custom_6 = item_giants_ring_custom

function item_giants_ring_custom:GetIntrinsicModifierName()
    return "modifier_giants_ring_custom_buff"
end

function item_giants_ring_custom:GetAOERadius()
    return self:GetSpecialValueFor("damage_radius")
end
-------------------

modifier_giants_ring_custom_buff = class({})

function modifier_giants_ring_custom_buff:IsHidden() return false end
function modifier_giants_ring_custom_buff:IsPurgable() return false end
function modifier_giants_ring_custom_buff:RemoveOnDeath() return false end
function modifier_giants_ring_custom_buff:IsStackable() return false end
function modifier_giants_ring_custom_buff:IsPurgeException() return false end

function modifier_giants_ring_custom_buff:CheckState()
    return {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
end

function modifier_giants_ring_custom_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_SCALE 
    }
    return funcs
end

function modifier_giants_ring_custom_buff:OnCreated()
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self:StartIntervalThink(1)
end

function modifier_giants_ring_custom_buff:OnRefresh()
    if not IsServer() then return end
	self.move_speed = self.ability:GetSpecialValueFor("movement_speed")
	self.scale = self.ability:GetSpecialValueFor("model_scale")
    self.radius = self.ability:GetSpecialValueFor("damage_radius")
	self.strength = self.ability:GetSpecialValueFor("bonus_strength") + (self.parent:GetBaseStrength() * (self.ability:GetSpecialValueFor("bonus_strength_pct")/100))
end

function modifier_giants_ring_custom_buff:OnIntervalThink()
	self:OnRefresh()
    local victims = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _,victim in ipairs(victims) do
		if not victim:IsAlive() then break end

        ApplyDamage({
            victim = victim,
            attacker = self.parent,
            damage = (self.parent:GetStrength() * (self.ability:GetSpecialValueFor("pct_str_damage_per_second")/100)),
            damage_type = DAMAGE_TYPE_MAGICAL,
        })
    end

    self.vfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(self.vfx, 0, self.parent:GetOrigin())
    ParticleManager:SetParticleControl(self.vfx, 1, Vector(self.radius, self.radius, self.radius))
    ParticleManager:ReleaseParticleIndex(self.vfx)
end

function modifier_giants_ring_custom_buff:GetModifierBonusStats_Strength()
    return self.strength
end

function modifier_giants_ring_custom_buff:GetModifierMoveSpeedBonus_Percentage()
    return self.move_speed
end

function modifier_giants_ring_custom_buff:GetModifierModelScale()
    return self.scale
end