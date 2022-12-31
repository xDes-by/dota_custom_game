---@class modifier_dawnbreaker_luminosity:CDOTA_Modifier_Lua
modifier_dawnbreaker_luminosity_lua = class({})

function modifier_dawnbreaker_luminosity_lua:IsPurgable() return false end

function modifier_dawnbreaker_luminosity_lua:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_dawnbreaker_luminosity_lua:IsHidden() 
	return self:GetStackCount() == 0
end

function modifier_dawnbreaker_luminosity_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_dawnbreaker_luminosity_lua:GetModifierProcAttack_Feedback(event)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local target = event.target

	if caster.split_attack then return end

	if not ability then
		self:Destroy()
		return
	end

	if caster:PassivesDisabled() or target:GetTeam() == caster:GetTeam() or target:IsOther() or target:IsBuilding() then return end

	local attack_count = ability:GetSpecialValueFor("attack_count") - caster:FindTalentValue("special_bonus_unique_dawnbreaker_luminosity_attack_count")

	if not caster:HasModifier("modifier_dawnbreaker_luminosity_attack_buff_lua") then
		self:IncrementStackCount()
	end

	if self:GetStackCount() == attack_count then
		Timers:CreateTimer(0.01, function()
			local buff = caster:AddNewModifier(caster, ability, "modifier_dawnbreaker_luminosity_attack_buff_lua", nil)

			if buff then
				buff:SetStackCount(attack_count)
			end
		end)

		self:SetStackCount(0)
	end
end

function modifier_dawnbreaker_luminosity_lua:OnDestroy()
	if IsClient() then return end

	local caster = self:GetCaster()

	if caster then
		caster:RemoveModifierByName("modifier_dawnbreaker_luminosity_attack_buff_lua")
	end
end
