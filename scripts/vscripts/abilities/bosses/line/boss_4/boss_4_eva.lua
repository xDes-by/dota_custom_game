LinkLuaModifier('modifier_boss_4_eva', "abilities/bosses/line/boss_4/boss_4_eva", LUA_MODIFIER_MOTION_NONE)

boss_4_eva = class({})

function boss_4_eva:GetIntrinsicModifierName() 
    return 'modifier_boss_4_eva'
end

---------------------------------------------------

modifier_boss_4_eva = class({})

function modifier_boss_4_eva:IsHidden()
	return true
end

function modifier_boss_4_eva:IsPurgable()
	return false
end

function modifier_boss_4_eva:RemoveOnDeath()
	return false
end

function modifier_boss_4_eva:OnCreated( kv )
end

function modifier_boss_4_eva:OnRefresh( kv )
end

function modifier_boss_4_eva:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_boss_4_eva:GetModifierIncomingDamage_Percentage()
	if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor( "persent" ) then
		local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(backtrack_fx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(backtrack_fx)
		return -100
	end
end