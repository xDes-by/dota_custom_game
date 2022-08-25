LinkLuaModifier( "modifier_ward_bash", "abilities/bosses/swamp/ward_bash", LUA_MODIFIER_MOTION_NONE )

ward_bash = class({})

function ward_bash:GetIntrinsicModifierName()
	return "modifier_ward_bash"
end

---------------------------------------------------------------------------------------------------------------

modifier_ward_bash = class({})

function modifier_ward_bash:IsHidden()
	return true
end

function modifier_ward_bash:IsDebuff()
	return false
end

function modifier_ward_bash:IsPurgable()
	return false
end

function modifier_ward_bash:RemoveOnDeath()
	return false
end

function modifier_ward_bash:OnCreated( kv )
end

function modifier_ward_bash:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_ward_bash:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_ward_bash:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() then
		if RandomInt(1,100) <= 25 then
			keys.target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 0.15 } )
		end
	end
end