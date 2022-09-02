ability_npc_boss_plague_squirrel_spell6 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell6", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell6", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_plague_squirrel_spell6:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_plague_squirrel_spell6", {duration = self:GetSpecialValueFor("duration")})
end

---------------------------------------------------------------------------

modifier_ability_npc_boss_plague_squirrel_spell6 = class({})

function modifier_ability_npc_boss_plague_squirrel_spell6:IsHidden()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell6:IsDebuff()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell6:IsPurgable()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell6:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_spell6:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_spell6:OnCreated()
    EmitSoundOn("Hero_TemplarAssassin.Refraction", self:GetCaster())
    self.min_damage_to_stack = self:GetAbility():GetSpecialValueFor("min_damage_to_stack")
    local pfx = ParticleManager:CreateParticle("particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refraction.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(pfx, 1, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 5, self:GetCaster():GetAbsOrigin())
	self:AddParticle(pfx,false,false,-1,false,false)
    self:SetStackCount(self:GetAbility():GetSpecialValueFor("stacks_count"))
    self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_pct") * 0.01 * self:GetCaster():GetAverageTrueAttackDamage(nil)
end

function modifier_ability_npc_boss_plague_squirrel_spell6:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_ability_npc_boss_plague_squirrel_spell6:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function modifier_ability_npc_boss_plague_squirrel_spell6:GetModifierIncomingDamage_Percentage(data)
	local pfx = ParticleManager:CreateParticle("particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refract_hit.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(pfx)
	EmitSoundOn("Hero_TemplarAssassin.Refraction.Absorb", self:GetCaster())
	self:DecrementStackCount()
	if self:GetStackCount() == 0 then
		self:Destroy()
	end
	return -100
end