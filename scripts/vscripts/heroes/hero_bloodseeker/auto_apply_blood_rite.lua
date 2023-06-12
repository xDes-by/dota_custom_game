npc_dota_hero_bloodseeker_agi_last = class({})
LinkLuaModifier( "modifier_auto_apply_blood_rite", "heroes/hero_bloodseeker/auto_apply_blood_rite", LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_bloodseeker_agi_last:GetIntrinsicModifierName()
	return "modifier_auto_apply_blood_rite"
end

modifier_auto_apply_blood_rite = class({})

function modifier_auto_apply_blood_rite:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_auto_apply_blood_rite:OnAttackLanded( params )
    if not IsServer() then return end
    if params.attacker == self:GetParent() and not params.target:IsBuilding() and params.attacker:GetTeamNumber() ~= params.target:GetTeamNumber() then
        local blood_rite = self:GetCaster():FindAbilityByName("bloodseeker_blood_rite_lua")
        if blood_rite and RollPseudoRandomPercentage(10, self:GetCaster():entindex(), self:GetCaster()) then
            blood_rite.cast_position = params.target:GetAbsOrigin()
            blood_rite:OnSpellStart()
        end
    end
end