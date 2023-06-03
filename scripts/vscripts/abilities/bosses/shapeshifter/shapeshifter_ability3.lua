LinkLuaModifier( "modifier_shapeshifter_ability3_buff", "abilities/bosses/shapeshifter/shapeshifter_ability3", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

shapeshifter_ability3 = class({})

function shapeshifter_ability3:OnSpellStart()
if not IsServer() then return end
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
	for _,ally in pairs(allies) do
		ally:AddNewModifier( self:GetCaster(), self, "modifier_shapeshifter_ability3_buff",  { duration = duration } )
	end
	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_Lycan.Howl", self:GetCaster())
	
	local particle_lycan_howl_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 0 , self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 1 , self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 2 , self:GetCaster():GetAbsOrigin())
end


---------------------------------------------------------------

modifier_shapeshifter_ability3_buff = class({})

function modifier_shapeshifter_ability3_buff:IsPurgable()		return false end
function modifier_shapeshifter_ability3_buff:RemoveOnDeath()	return false end
function modifier_shapeshifter_ability3_buff:IsHidden() return false end

function modifier_shapeshifter_ability3_buff:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

function modifier_shapeshifter_ability3_buff:OnCreated()
end

function modifier_shapeshifter_ability3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_shapeshifter_ability3_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "as" )
end

function modifier_shapeshifter_ability3_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor( "movespeed" )
end

function modifier_shapeshifter_ability3_buff:GetModifierPreAttack_BonusDamage()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lycan_tal1")
	if abil ~= nil and abil:GetLevel() > 0 then 
		return 50
	end
	return 0	
end
