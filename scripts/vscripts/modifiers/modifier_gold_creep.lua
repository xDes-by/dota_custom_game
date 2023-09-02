modifier_gold_creep = class({})
--Classifications template
function modifier_gold_creep:IsHidden()
    return false
end

function modifier_gold_creep:IsDebuff()
    return false
end

function modifier_gold_creep:IsPurgable()
    return false
end

function modifier_gold_creep:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_gold_creep:IsStunDebuff()
    return false
end

function modifier_gold_creep:RemoveOnDeath()
    return true
end

function modifier_gold_creep:DestroyOnExpire()
    return false
end

function modifier_gold_creep:OnCreated()
    self.parent = self:GetParent()
    self.health = self.parent:GetMaxHealth() * 4
    self.damage = self.parent:GetBaseDamageMax() * 4
    self.armor = self.parent:GetPhysicalArmorBaseValue() * 4
    -- self.part = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
    self.part = ParticleManager:CreateParticle( "particles/econ/events/ti9/high_five/high_five_lvl3_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
    if self.parent:GetUnitName() == "farm_zone_dragon" then
        self.health = self.health / 2
        self.armor = self.armor / 2
        self.damage = self.damage / 2
    end
end

function modifier_gold_creep:OnDestroy()
    ParticleManager:DestroyParticle(self.part, false)
    if not IsServer() then
        return
    end
    for iPlayerID=0,4 do
        if PlayerResource:IsValidPlayer(iPlayerID) then
            PlayerResource:ModifyGold(iPlayerID, self.parent:GetGoldBounty(), true, DOTA_ModifyGold_SharedGold)
        end
    end
end

function modifier_gold_creep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_gold_creep:GetModifierExtraHealthBonus()
    return self.health
end

function modifier_gold_creep:GetModifierModelScale()
    return 50
end

function modifier_gold_creep:GetModifierBaseAttack_BonusDamage()
    return self.damage
end

function modifier_gold_creep:GetModifierMagicalResistanceBonus()
    return 25
end

function modifier_gold_creep:GetModifierPhysicalArmorBonus()
    return self.armor
end

function modifier_gold_creep:GetModifierIncomingDamage_Percentage()
	local caster = self:GetCaster()
	max_chance = 30
	local r5 = RandomInt(1,100)
	if r5 <= max_chance then
		local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(backtrack_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(backtrack_fx)
		return -100
	end
end