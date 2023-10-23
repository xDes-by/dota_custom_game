mega_boss_mana_remove = class({})

LinkLuaModifier( "modifier_mega_boss_mana_remove", "abilities/bosses/mega/mega_boss_mana_remove", LUA_MODIFIER_MOTION_NONE )

function mega_boss_mana_remove:GetIntrinsicModifierName()
    return "modifier_mega_boss_mana_remove"
end

modifier_mega_boss_mana_remove = class({})

modifier_mega_boss_mana_remove = class({})
--Classifications template
function modifier_mega_boss_mana_remove:IsHidden()
    return true
end

function modifier_mega_boss_mana_remove:IsDebuff()
    return false
end

function modifier_mega_boss_mana_remove:IsPurgable()
    return false
end

function modifier_mega_boss_mana_remove:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_mega_boss_mana_remove:IsStunDebuff()
    return false
end

function modifier_mega_boss_mana_remove:RemoveOnDeath()
    return false
end

function modifier_mega_boss_mana_remove:DestroyOnExpire()
    return false
end

function modifier_mega_boss_mana_remove:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_mega_boss_mana_remove:OnAttackLanded(data)
    if data.attacker ~= self:GetParent() then
        return
    end
    if RandomFloat(0, 100) < 0.5 then
        data.target:SetMana(0)
        local abi = data.attacker:FindAbilityByName("mega_boss_mana_void")
        if abi then
            abi:EndCooldown()
            local cp = abi:GetCastPoint()
            abi:SetOverrideCastPoint(0)
            data.attacker:CastAbilityOnTarget(data.target, abi, -1)
            abi:SetOverrideCastPoint(cp)
        end
    end
end