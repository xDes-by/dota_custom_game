m_resist = class({})
LinkLuaModifier( "modifier_m_resist", "abilities/talents/m_resist", LUA_MODIFIER_MOTION_NONE )

function m_resist:GetIntrinsicModifierName()
	return "modifier_m_resist"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_m_resist = class({})

function modifier_m_resist:IsHidden()
	return true
end

function modifier_m_resist:IsPurgable()
	return false
end

function modifier_m_resist:RemoveOnDeath()
	return false
end

function modifier_m_resist:OnCreated( kv )
	self.caster = self:GetCaster()
	self.m_resist = self:GetAbility():GetSpecialValueFor( "m_resist" )
end

function modifier_m_resist:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.m_resist = self:GetAbility():GetSpecialValueFor( "m_resist" )
end

function modifier_m_resist:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_m_resist:GetModifierMagicalResistanceBonus()
	return self.m_resist
end