innate_breaker = class({})

LinkLuaModifier("modifier_innate_breaker", "heroes/innates/breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_breaker_debuff", "heroes/innates/breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_breaker_cooldown", "heroes/innates/breaker", LUA_MODIFIER_MOTION_NONE)

function innate_breaker:GetIntrinsicModifierName()
	return "modifier_innate_breaker"
end



modifier_innate_breaker = class({})

function modifier_innate_breaker:IsHidden() return true end
function modifier_innate_breaker:IsDebuff() return false end
function modifier_innate_breaker:IsPurgable() return false end
function modifier_innate_breaker:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_breaker:IsAura() return true end
function modifier_innate_breaker:GetAuraRadius() return self.radius or 1200 end
function modifier_innate_breaker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_innate_breaker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_innate_breaker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_innate_breaker:GetModifierAura() return "modifier_innate_breaker_debuff" end
function modifier_innate_breaker:GetAuraDuration() return 0.1 end  -- linger time

function modifier_innate_breaker:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_breaker:OnRefresh(keys)
	if IsClient() then return end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	self.radius = ability:GetLevelSpecialValueFor("aura_radius", 1)
end



modifier_innate_breaker_debuff = class({})

function modifier_innate_breaker_debuff:IsHidden() return false end
function modifier_innate_breaker_debuff:IsDebuff() return true end
function modifier_innate_breaker_debuff:IsPurgable() return false end

function modifier_innate_breaker_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_break.vpcf"
end

function modifier_innate_breaker_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_innate_breaker_debuff:CheckState()
	return {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
end


--[[
modifier_innate_breaker_cooldown = class({})

function modifier_innate_breaker_cooldown:IsHidden() return false end
function modifier_innate_breaker_cooldown:IsDebuff() return true end
function modifier_innate_breaker_cooldown:IsPurgable() return false end
function modifier_innate_breaker_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_breaker_cooldown:GetTexture() return "innate_breaker" end
]]
