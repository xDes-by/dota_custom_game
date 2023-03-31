npc_dota_hero_arc_warden_int7 = class({})

LinkLuaModifier( "modifier_npc_dota_hero_arc_warden_int7","heroes/hero_arc/npc_dota_hero_arc_warden_int7", LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_arc_warden_int7:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_arc_warden_int7"
end

modifier_npc_dota_hero_arc_warden_int7 = class({})

--Classifications template
function modifier_npc_dota_hero_arc_warden_int7:IsHidden()
    return true
end

function modifier_npc_dota_hero_arc_warden_int7:IsPurgable()
    return false
end

function modifier_npc_dota_hero_arc_warden_int7:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_arc_warden_int7:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_npc_dota_hero_arc_warden_int7:OnCreated()
    if IsClient() then
        return
    end
    self.abi = self:GetCaster():FindAbilityByName("ark_spark_lua")
    self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_arc_warden_int7:OnIntervalThink()
    if self:GetCaster():IsAlive() and self.abi:GetLevel() > 0 then
		self.abi:OnSpellStart()
    end
end
