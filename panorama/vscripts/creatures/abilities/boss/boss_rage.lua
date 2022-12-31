LinkLuaModifier("modifier_boss_rage", "creatures/abilities/boss/boss_rage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_boss_rage_effect", "creatures/abilities/boss/boss_rage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_boss_super_rage_effect", "creatures/abilities/boss/boss_rage", LUA_MODIFIER_MOTION_NONE )

boss_rage = class({})

function boss_rage:GetIntrinsicModifierName()
	if IsServer() then
		return "modifier_boss_rage"
	end
end

modifier_boss_rage = class({})

function modifier_boss_rage:IsHidden() return true end
function modifier_boss_rage:IsDebuff() return false end
function modifier_boss_rage:IsPurgable() return false end

function modifier_boss_rage:OnCreated(keys)
	if IsServer() then
		self.rage_active = false
		self.super_rage_active = false

		self:StartIntervalThink(0.1)
	end
end

function modifier_boss_rage:OnIntervalThink()
	if IsServer() then
		if (not self.rage_active) and self:GetCaster():GetHealthPercent() <= 50 then
			self:GetCaster():EmitSound("BossRage.Cast")
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_boss_rage_effect", {})
			self.rage_active = true
		end

		if (not self.super_rage_active) and self:GetCaster():GetHealthPercent() <= 25 then
			self:GetCaster():EmitSound("BossRage.Cast")
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_boss_super_rage_effect", {})
			self.super_rage_active = true
		end
	end
end





modifier_boss_rage_effect = class({})

function modifier_boss_rage_effect:IsHidden() return true end
function modifier_boss_rage_effect:IsDebuff() return false end
function modifier_boss_rage_effect:IsPurgable() return false end

function modifier_boss_rage_effect:GetEffectName()
	return "particles/creature/boss_rage_b.vpcf"
end

function modifier_boss_rage_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boss_rage_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_boss_rage_effect:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end





modifier_boss_super_rage_effect = class({})

function modifier_boss_super_rage_effect:IsHidden() return true end
function modifier_boss_super_rage_effect:IsDebuff() return false end
function modifier_boss_super_rage_effect:IsPurgable() return false end

function modifier_boss_super_rage_effect:GetEffectName()
	return "particles/creature/boss_rage.vpcf"
end

function modifier_boss_super_rage_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boss_super_rage_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_boss_super_rage_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end
