modifier_medusa_stone_gaze_lua = class({})

function modifier_medusa_stone_gaze_lua:IsHidden()
	return true
end

function modifier_medusa_stone_gaze_lua:IsPurgable()
	return false
end

function modifier_medusa_stone_gaze_lua:IsAuraActiveOnDeath() return false end

function modifier_medusa_stone_gaze_lua:IsAura()
    return true
end

function modifier_medusa_stone_gaze_lua:GetModifierAura()
    return "modifier_modifier_medusa_stone_gaze_visual_lua"
end

function modifier_medusa_stone_gaze_lua:GetAuraRadius()
    return 600
end

function modifier_medusa_stone_gaze_lua:GetAuraDuration()
    return 0
end

function modifier_medusa_stone_gaze_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_medusa_stone_gaze_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end