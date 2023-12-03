item_quelling_blade_lua = class({})

LinkLuaModifier("modifier_item_quelling_blade_lua", "items/other/item_quelling_blade_lua.lua", LUA_MODIFIER_MOTION_NONE)

function item_quelling_blade_lua:OnSpellStart()
    local caster = self:GetCaster()
    local target_point = self:GetCursorPosition()
    local pos = Vector(6745, -2921, 261)
    if (target_point - pos):Length2D() < 400 then
        local trees = GridNav:GetAllTreesAroundPoint(target_point, 400, false)
        for _, tree in pairs(trees) do
            SetContextThink("self_destroy", function(tree) 
				if tree:IsStanding() then 
					tree:CutDown(DOTA_TEAM_GOODGUYS)
				end
				return 0.1
			end, 0.1)
        end
    else
        GridNav:DestroyTreesAroundPoint(target_point, 1, false)
    end
end

function item_quelling_blade_lua:GetIntrinsicModifierName()
    return "modifier_item_quelling_blade_lua"
end

modifier_item_quelling_blade_lua = class({})
--Classifications template
function modifier_item_quelling_blade_lua:IsHidden()
    return true
end

function modifier_item_quelling_blade_lua:IsDebuff()
    return false
end

function modifier_item_quelling_blade_lua:IsPurgable()
    return false
end

function modifier_item_quelling_blade_lua:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_item_quelling_blade_lua:IsStunDebuff()
    return false
end

function modifier_item_quelling_blade_lua:RemoveOnDeath()
    return false
end

function modifier_item_quelling_blade_lua:DestroyOnExpire()
    return true
end

function modifier_item_quelling_blade_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
    }
end

function modifier_item_quelling_blade_lua:GetModifierProcAttack_BonusDamage_Physical()
    if self:GetParent():IsRangedAttacker() then
        return self:GetAbility():GetSpecialValueFor("damage_bonus_ranged")
    end
    return self:GetAbility():GetSpecialValueFor("damage_bonus")
end