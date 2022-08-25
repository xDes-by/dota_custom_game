modifier_drow_ranger_aura_effect = class({})

function modifier_drow_ranger_aura_effect:IsHidden()
	return false
end

function modifier_drow_ranger_aura_effect:IsDebuff()
	return false
end

function modifier_drow_ranger_aura_effect:IsPurgable()
	return false
end


function modifier_drow_ranger_aura_effect:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_drow_ranger_aura_effect:OnRefresh( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_drow_ranger_aura_effect:OnDestroy( kv )

end

function modifier_drow_ranger_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_drow_ranger_aura_effect:GetModifierAttackSpeedBonus_Constant()
	local caster = self:GetCaster()
		local agility = caster:GetAgility()
	local true_speed = (agility / 100) * self.speed
	return true_speed
end