all_evasion = class({})
LinkLuaModifier( "modifier_all_evasion", "abilities/talents/all_evasion", LUA_MODIFIER_MOTION_NONE )

function all_evasion:GetIntrinsicModifierName()
	return "modifier_all_evasion"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_all_evasion = class({})

function modifier_all_evasion:IsHidden()
	return true
end

function modifier_all_evasion:IsPurgable()
	return false
end

function modifier_all_evasion:RemoveOnDeath()
	return false
end

function modifier_all_evasion:OnCreated( kv )
	self.caster = self:GetCaster()
end

function modifier_all_evasion:OnRefresh( kv )
end

function modifier_all_evasion:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_all_evasion:GetModifierIncomingDamage_Percentage()
	local caster	=	self:GetCaster()
	max_chance = 15 --self:GetAbility():GetSpecialValueFor( "all_evasion" )
	
	local r5 = RandomInt(1,100)
	if r5 <= max_chance then
		local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(backtrack_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(backtrack_fx)
		return -100
	end
end