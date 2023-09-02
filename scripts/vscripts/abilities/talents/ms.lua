movespeed = class({})

LinkLuaModifier( "modifier_armor_curruption", "abilities/talents/ms", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_armor_curruption_talent", "abilities/talents/ms", LUA_MODIFIER_MOTION_NONE )

function movespeed:GetIntrinsicModifierName()
	return "modifier_armor_curruption"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_armor_curruption = class({})

function modifier_armor_curruption:IsHidden()
	return true
end

function modifier_armor_curruption:IsPurgable()
	return false
end

function modifier_armor_curruption:RemoveOnDeath()
	return false
end

function modifier_armor_curruption:OnCreated( kv )
	self.caster = self:GetCaster()
	self.armor_curruption = self:GetAbility():GetSpecialValueFor( "armor_curruption" ) * -1
end

function modifier_armor_curruption:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.armor_curruption = self:GetAbility():GetSpecialValueFor( "armor_curruption" ) * -1
end

function modifier_armor_curruption:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end

function modifier_armor_curruption:GetModifierProcAttack_Feedback(data)
	data.target:AddNewModifier(self.caster, self.abi, "modifier_armor_curruption_talent", {duration = 3, armor_curruption = self.armor_curruption})
end

modifier_armor_curruption_talent = class({})
--Classifications template
function modifier_armor_curruption_talent:IsHidden()
	return false
end

function modifier_armor_curruption_talent:IsDebuff()
	return true
end

function modifier_armor_curruption_talent:IsPurgable()
	return false
end

function modifier_armor_curruption_talent:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_armor_curruption_talent:IsStunDebuff()
	return false
end

function modifier_armor_curruption_talent:RemoveOnDeath()
	return true
end

function modifier_armor_curruption_talent:DestroyOnExpire()
	return true
end

function modifier_armor_curruption_talent:OnCreated(data)
	self.armor_curruption = data.armor_curruption
	self:SetStackCount(1)
end

function modifier_armor_curruption_talent:OnRefresh()
	if not IsServer() then
		return
	end
	self:IncrementStackCount()
end

function modifier_armor_curruption:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_armor_curruption:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_curruption
end