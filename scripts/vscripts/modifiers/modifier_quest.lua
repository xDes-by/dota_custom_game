if modifier_quest == nil then
	modifier_quest = class({})
end

function modifier_quest:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return funcs
end

function modifier_quest:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = false,
	}

  	return state
end

function modifier_quest:GetAbsoluteNoDamageMagical()
  	return 1
end

function modifier_quest:GetAbsoluteNoDamagePhysical()
  	return 1
end

function modifier_quest:GetAbsoluteNoDamagePure()
  	return 1
end

function modifier_quest:GetMinHealth()
  	return 1
end

function modifier_quest:IsHidden()
    return true
end

function modifier_quest:IsAura()
  	return true
end

function modifier_quest:GetModifierAura()
  	return "modifier_quest_aura"
end

function modifier_quest:GetAuraRadius()
  	return 250
end

function modifier_quest:GetAuraSearchType()
  	return DOTA_UNIT_TARGET_HERO
end

function modifier_quest:GetAuraSearchTeam()
  	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_quest:GetAuraDuration()
  	return 0.1
end