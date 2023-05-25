LinkLuaModifier("modifier_boss_10_flame", "abilities/bosses/line/boss_10/boss_10_flame", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_10_flame_fire", "abilities/bosses/line/boss_10/boss_10_flame", LUA_MODIFIER_MOTION_NONE)

boss_10_flame = class({})

function boss_10_flame:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function boss_10_flame:GetIntrinsicModifierName()
	return "modifier_boss_10_flame"
end

function boss_10_flame:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function boss_10_flame:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_boss_10_flame = class({})

function modifier_boss_10_flame:IsHidden()
	return true
end

function modifier_boss_10_flame:IsPurgable()
	return false
end

function modifier_boss_10_flame:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_boss_10_flame:OnTakeDamage( params )
	if not IsServer() then return end

	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	params.attacker:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_boss_10_flame_fire", { duration = self:GetAbility():GetSpecialValueFor( "duration" ) * (1 - params.attacker:GetStatusResistance())}	)
end

--------------------------------------------------------------------------------------

modifier_boss_10_flame_fire = class({})

function modifier_boss_10_flame_fire:IsHidden()
	return false
end

function modifier_boss_10_flame_fire:IsDebuff()
	return true
end

function modifier_boss_10_flame_fire:IsStunDebuff()
	return false
end

function modifier_boss_10_flame_fire:IsPurgable()
	return true
end

function modifier_boss_10_flame_fire:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
	}
	
	self:StartIntervalThink( 1 )
end

function modifier_boss_10_flame_fire:OnRefresh( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end
	self.damageTable.damage = damage
end


function modifier_boss_10_flame_fire:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_boss_10_flame_fire:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf"
end

function modifier_boss_10_flame_fire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end