ability_npc_boss_plague_squirrel_spell7 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell7","abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell7", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_plague_squirrel_spell7:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_plague_squirrel_spell7"
end

function ability_npc_boss_plague_squirrel_spell7:OnOwnerDied()
    self:StartCooldown(99999)
end

modifier_ability_npc_boss_plague_squirrel_spell7 = class({})

--Classifications template
function modifier_ability_npc_boss_plague_squirrel_spell7:IsHidden()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_spell7:IsPurgable()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell7:RemoveOnDeath()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell7:OnCreated()
    self.chance_evation = self:GetAbility():GetSpecialValueFor("chance_evation")
    self.chance_attack = self:GetAbility():GetSpecialValueFor("chance_attack")
    if IsClient() then
        return
    end
    self.abi = self:GetCaster():FindAbilityByName("ability_npc_boss_plague_squirrel_spell1")
end

function modifier_ability_npc_boss_plague_squirrel_spell7:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_REINCARNATION,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_ability_npc_boss_plague_squirrel_spell7:ReincarnateTime()
    if self:GetAbility():IsCooldownReady() then
        return 5
    end
end

function modifier_ability_npc_boss_plague_squirrel_spell7:GetModifierIncomingDamage_Percentage()
	if RandomInt(1,100) <= self.chance_evation then
		local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(backtrack_fx)
		return -100
	end
end

function modifier_ability_npc_boss_plague_squirrel_spell7:OnAttack(data)
    if self:GetParent() == data.attacker then
        if self.abi and RandomInt(1,100) <= self.chance_attack then
            self.abi:CreateTree_OtherAbilities(data.target:GetOrigin())
        end
    end
end