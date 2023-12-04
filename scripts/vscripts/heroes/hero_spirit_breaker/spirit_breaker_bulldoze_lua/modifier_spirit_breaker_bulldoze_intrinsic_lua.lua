modifier_spirit_breaker_bulldoze_intrinsic_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spirit_breaker_bulldoze_intrinsic_lua:IsHidden()
	return true
end

function modifier_spirit_breaker_bulldoze_intrinsic_lua:IsDebuff()
	return false
end

function modifier_spirit_breaker_bulldoze_intrinsic_lua:IsPurgable()
	return false
end

function modifier_spirit_breaker_bulldoze_intrinsic_lua:RemoveOnDeath()
	return false
end

function modifier_spirit_breaker_bulldoze_intrinsic_lua:OnCreated(kv)
    self.caster = self:GetCaster()
    if IsServer() then
        self:StartIntervalThink(0.2)
    end
end

function modifier_spirit_breaker_bulldoze_intrinsic_lua:OnIntervalThink()
    if self.caster:FindAbilityByName("npc_dota_hero_spirit_breaker_str10") and not self.permanentModifier then
        self.permanentModifier = self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_spirit_breaker_bulldoze_lua", {})
    elseif self.caster:FindAbilityByName("npc_dota_hero_spirit_breaker_str10") == nil and  self.permanentModifier then
        self.permanentModifier:Destroy()
        self.permanentModifier = nil
    end
end