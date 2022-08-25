fontan_aura = class({})
LinkLuaModifier( "modifier_fontan_aura", "abilities/fontan_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fontan_aura_effect", "abilities/fontan_aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function fontan_aura:GetIntrinsicModifierName()
	return "modifier_fontan_aura"
end

modifier_fontan_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_fontan_aura:IsHidden()
	return true
end

function modifier_fontan_aura:IsDebuff()
	return false
end

function modifier_fontan_aura:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
-- Aura
function modifier_fontan_aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_fontan_aura:GetModifierAura()
	return "modifier_fontan_aura_effect"
end

function modifier_fontan_aura:GetAuraRadius()
	return 500
end

function modifier_fontan_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_fontan_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

modifier_fontan_aura_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_fontan_aura_effect:IsHidden()
	return false
end

function modifier_fontan_aura_effect:IsDebuff()
	return false
end

function modifier_fontan_aura_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_fontan_aura_effect:OnCreated( kv )
		if not IsServer() then return end
	local ability = self:GetAbility()

	self.health_regen_aura = self:GetAbility():GetSpecialValueFor( "health_regen_aura" ) -- special value
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor( "mana_regen_aura" ) -- special value
		
	local effect = "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration_heal.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector( ability.aura_radius, ability.aura_radius, ability.aura_radius ) )
	ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(pfx, true, false, 0, true, false)
end

function modifier_fontan_aura_effect:OnRefresh( kv )
	-- references
	self.health_regen_aura = self:GetAbility():GetSpecialValueFor( "health_regen_aura" ) -- special value
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor( "mana_regen_aura" ) -- special value
end

function modifier_fontan_aura_effect:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_fontan_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end

function modifier_fontan_aura_effect:GetModifierTotalPercentageManaRegen()
return self.mana_regen_aura
end

function modifier_fontan_aura_effect:GetModifierHealthRegenPercentage()
return self.health_regen_aura
end

-- function fontan_aura_effect:GetModifierBaseRegen()
-- 	return 
-- end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function fontan_aura_effect:GetEffectName()
-- 	return "particles/string/here.vpcf"
-- end

-- function fontan_aura_effect:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end