innate_twinstrike = class({})

LinkLuaModifier("modifier_innate_twinstrike", "heroes/innates/twinstrike", LUA_MODIFIER_MOTION_NONE)

function innate_twinstrike:GetIntrinsicModifierName()
	return "modifier_innate_twinstrike"
end





modifier_innate_twinstrike = class({})

function modifier_innate_twinstrike:IsHidden() return true end
function modifier_innate_twinstrike:IsDebuff() return false end
function modifier_innate_twinstrike:IsPurgable() return false end
function modifier_innate_twinstrike:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_twinstrike:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_twinstrike:OnRefresh(keys)
	if IsClient() then return end

	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.proc_chance = ability:GetSpecialValueFor("extra_attack_chance") or 0
	self.proc_delay = ability:GetSpecialValueFor("attack_delay") or 0
end

function modifier_innate_twinstrike:DeclareFunctions()
	if IsServer() then return {	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK } end
end

function modifier_innate_twinstrike:GetModifierProcAttack_Feedback(keys)
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end

	-- Prevents marksmanship attack count explosion
	if keys.attacker.split_attack then return end

	if RollPercentage(self.proc_chance) then
		Timers:CreateTimer(self.proc_delay, function()
			if keys.attacker and keys.target and not (keys.attacker:IsNull() or keys.target:IsNull()) and keys.attacker:IsAlive() and keys.target:IsAlive() then
				keys.attacker:PerformAttack(keys.target, true, true, true, false, true, false, false)
			end
		end)
	end
end
