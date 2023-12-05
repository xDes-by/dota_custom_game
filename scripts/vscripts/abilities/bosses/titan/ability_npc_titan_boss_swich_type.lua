ability_npc_titan_boss_swich_type = class({})

function ability_npc_titan_boss_swich_type:GetIntrinsicModifierName()
    return "modifier_ability_npc_titan_boss_swich_type"
end

modifier_ability_npc_titan_boss_swich_type = class({})

LinkLuaModifier("modifier_ability_npc_titan_boss_swich_type", "abilities/bosses/titan/ability_npc_titan_boss_swich_type.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_npc_titan_boss_swich_type_magic", "abilities/bosses/titan/ability_npc_titan_boss_swich_type.lua", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_titan_boss_swich_type:IsHidden()
    return true
end

function modifier_ability_npc_titan_boss_swich_type:IsDebuff()
    return false
end

function modifier_ability_npc_titan_boss_swich_type:IsPurgable()
    return false
end

function modifier_ability_npc_titan_boss_swich_type:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_titan_boss_swich_type:IsStunDebuff()
    return false
end

function modifier_ability_npc_titan_boss_swich_type:RemoveOnDeath()
    return false
end

function modifier_ability_npc_titan_boss_swich_type:DestroyOnExpire()
    return false
end

function modifier_ability_npc_titan_boss_swich_type:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.duration_physycal = self:GetAbility():GetSpecialValueFor("duration_physycal")
    self.duration_magical = self:GetAbility():GetSpecialValueFor("duration_magical")
    self.active = self.duration_physycal
    self:GetParent().stomp_type = "physical"
    self:StartIntervalThink(self.duration_physycal)
end

function modifier_ability_npc_titan_boss_swich_type:OnIntervalThink()
    if self:GetParent().stomp_type == "physical" then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ability_npc_titan_boss_swich_type_magic", {duration = self.duration_magical})
        self:GetParent().stomp_type = "magical"
        self:StartIntervalThink(self.duration_magical)
        -- EmitSoundOn("DOTA_Item.GhostScepter.Activate", self:GetParent())
    end
    if self:GetParent().stomp_type == "magical" then
        self:GetParent().stomp_type = "physical"
        self:StartIntervalThink(self.duration_physycal)
    end
end

modifier_ability_npc_titan_boss_swich_type_magic = class({})
--Classifications template
function modifier_ability_npc_titan_boss_swich_type_magic:IsHidden()
    return true
end

function modifier_ability_npc_titan_boss_swich_type_magic:IsDebuff()
    return false
end

function modifier_ability_npc_titan_boss_swich_type_magic:IsPurgable()
    return false
end

function modifier_ability_npc_titan_boss_swich_type_magic:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_titan_boss_swich_type_magic:IsStunDebuff()
    return false
end

function modifier_ability_npc_titan_boss_swich_type_magic:RemoveOnDeath()
    return true
end

function modifier_ability_npc_titan_boss_swich_type_magic:DestroyOnExpire()
    return true
end

function modifier_ability_npc_titan_boss_swich_type_magic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
	}
end

function modifier_ability_npc_titan_boss_swich_type_magic:GetModifierTotalDamageOutgoing_Percentage( params )
	if params.inflictor then return 0 end
	if params.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
	if params.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end
    ApplyDamage( {
        victim = params.target,
        attacker = self:GetParent(),
        damage = params.original_damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flag = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK,
        ability = self:GetAbility()
    })
	return -200
end

function modifier_ability_npc_titan_boss_swich_type_magic:GetOverrideAttackMagical()
	return true
end

function modifier_ability_npc_titan_boss_swich_type_magic:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_ability_npc_titan_boss_swich_type_magic:CheckState()
	return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
end

function modifier_ability_npc_titan_boss_swich_type_magic:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
end

function modifier_ability_npc_titan_boss_swich_type_magic:GetAbsoluteNoDamagePhysical()
	return true
end