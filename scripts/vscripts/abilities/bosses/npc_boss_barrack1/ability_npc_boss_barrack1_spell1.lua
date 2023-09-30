ability_npc_boss_barrack1_spell1 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell1","abilities/bosses/npc_boss_barrack1/ability_npc_boss_barrack1_spell1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell1_call","abilities/bosses/npc_boss_barrack1/ability_npc_boss_barrack1_spell1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell1_carapase","abilities/bosses/npc_boss_barrack1/ability_npc_boss_barrack1_spell1", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_barrack1_spell1:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_barrack1_spell1"
end

modifier_ability_npc_boss_barrack1_spell1 = class({})

--Classifications template
function modifier_ability_npc_boss_barrack1_spell1:IsHidden()
    return true
end

function modifier_ability_npc_boss_barrack1_spell1:IsPurgable()
    return false
end

function modifier_ability_npc_boss_barrack1_spell1:RemoveOnDeath()
    return false
end

function modifier_ability_npc_boss_barrack1_spell1:OnCreated()
    if IsClient() then
        return
    end
    self:StartIntervalThink(0.1)
end

function modifier_ability_npc_boss_barrack1_spell1:OnIntervalThink()
    local origin = self:GetCaster():GetOrigin()
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), origin, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    if #enemies >= 2 then
        for _,unit in pairs(enemies) do
            unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_boss_barrack1_spell1_call", {})
        end
    end
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), origin, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    if #enemies >= 2 then
        self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_boss_barrack1_spell1_carapase", {})
    end
end

modifier_ability_npc_boss_barrack1_spell1_call = class({})
--Classifications template
function modifier_ability_npc_boss_barrack1_spell1_call:IsHidden()
    return false
end

function modifier_ability_npc_boss_barrack1_spell1_call:IsDebuff()
    return true
end

function modifier_ability_npc_boss_barrack1_spell1_call:IsPurgable()
    return false
end

function modifier_ability_npc_boss_barrack1_spell1_call:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_barrack1_spell1_call:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_barrack1_spell1_call:OnCreated()
    if IsClient() then
        return
    end
    self:GetParent():MoveToTargetToAttack( self:GetCaster() )
    self:StartIntervalThink(0.2)
end

function modifier_ability_npc_boss_barrack1_spell1_call:OnRefresh()
    self:StartIntervalThink(0.2)
end

function modifier_ability_npc_boss_barrack1_spell1_call:OnIntervalThink()
    self:Destroy()
end

function modifier_ability_npc_boss_barrack1_spell1_call:CheckState()
    return {
        [MODIFIER_STATE_TAUNTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end

modifier_ability_npc_boss_barrack1_spell1_carapase = class({})
--Classifications template
function modifier_ability_npc_boss_barrack1_spell1_carapase:IsHidden()
    return false
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:IsDebuff()
    return false
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:IsPurgable()
    return false
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:OnCreated()
    EmitSoundOn("DOTA_Item.InvisibilitySword.Activate", self:GetParent())
    self.pfx = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_blademail_v2.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
    self.damage_multip = self:GetAbility():GetSpecialValueFor("damge_multip") * 0.01
    self:StartIntervalThink(0.2)
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:OnRefresh()
    self:StartIntervalThink(0.2)
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:OnIntervalThink()
    self:Destroy()
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:OnDestroy()
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_ability_npc_boss_barrack1_spell1_carapase:OnTakeDamage(data)
    if data.unit == self:GetParent() then
        ApplyDamage({victim = data.attacker,
        damage = data.damage * self.damage_multip * 3,
        damage_type = data.damage_type,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        attacker = self:GetCaster(),
        ability = self:GetAbility()})
        if data.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
            EmitSoundOn("DOTA_Item.BladeMail.Damage", data.unit)
            data.attacker:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 0.3})
        end
    end
end