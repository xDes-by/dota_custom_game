LinkLuaModifier("modifier_creature_mana_shield_aux", "creatures/abilities/regular/creature_mana_shield_aux", LUA_MODIFIER_MOTION_NONE)

creature_mana_shield_aux = class({})

function creature_mana_shield_aux:GetIntrinsicModifierName()
	return "modifier_creature_mana_shield_aux"
end



modifier_creature_mana_shield_aux = class({})

function modifier_creature_mana_shield_aux:IsHidden() return true end
function modifier_creature_mana_shield_aux:IsDebuff() return false end
function modifier_creature_mana_shield_aux:IsPurgable() return false end
function modifier_creature_mana_shield_aux:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_mana_shield_aux:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()

		Timers:CreateTimer(1, function()
			if not parent or parent:IsNull() then return end
			parent:FindAbilityByName("creature_mana_shield"):ToggleAbility()
			parent:RemoveModifierByName("modifier_creature_extra_mana")
			local modifier_extra_mana = parent:AddNewModifier(parent, nil, "modifier_creature_extra_mana", {})
			if modifier_extra_mana then
				modifier_extra_mana:SetStackCount(parent:GetMaxHealth() * 3)
			end
			parent:SetMana(0)
		end)
	end
end
