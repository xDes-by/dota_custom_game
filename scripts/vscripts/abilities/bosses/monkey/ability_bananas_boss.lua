ability_bananas_boss = class({})

LinkLuaModifier( "modifier_bananas_boss", "abilities/bosses/monkey/ability_bananas_boss", LUA_MODIFIER_MOTION_NONE )

function ability_bananas_boss:OnSpellStart()
    for i = 1, 3 do
        local dummy = CreateUnitByName('npc_dummy_unit', self:GetCaster():GetAbsOrigin() + RandomVector(RandomInt(300, 600)), false, nil,nil, self:GetCaster():GetTeamNumber())
        dummy:AddNewModifier(dummy, self, "modifier_dummy", {})
        dummy:AddNewModifier(self:GetCaster(), self, "modifier_bananas_boss", {duration = 10})
    end
end

modifier_bananas_boss = class({})

function modifier_bananas_boss:IsHidden()
    return true
end

function modifier_bananas_boss:IsDebuff()
    return false
end

function modifier_bananas_boss:IsPurgable()
    return false
end

function modifier_bananas_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_bananas_boss:IsStunDebuff()
    return false
end

function modifier_bananas_boss:RemoveOnDeath()
    return false
end

function modifier_bananas_boss:DestroyOnExpire()
    return false
end

function modifier_bananas_boss:OnCreated()
    if not IsServer() then
        return
    end
    EmitSoundOn("Item.LotusOrb.Target", self:GetParent())
    self:GetParent():SetModel("models/props_gameplay/banana_prop_closed_mk.vmdl")
    self.part = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/veno_tnt_banana_ground.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    self:StartIntervalThink(FrameTime())
end

function modifier_bananas_boss:OnIntervalThink()
    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 150,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #units > 0 then
        for _, unit in pairs(units) do
            unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = 5})
        end
        ParticleManager:DestroyParticle(self.part, true)
        ParticleManager:ReleaseParticleIndex(self.part)
        EmitSoundOn("Item.LotusOrb.Activate", self:GetParent())
        UTIL_Remove(self:GetParent())
    end
end

