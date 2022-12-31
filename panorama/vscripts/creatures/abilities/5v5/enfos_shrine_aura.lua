enfos_shrine_aura = class({})
LinkLuaModifier("modifier_enfos_shrine_aura", "creatures/abilities/5v5/enfos_shrine_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_shrine_aura_effect", "creatures/abilities/5v5/enfos_shrine_aura", LUA_MODIFIER_MOTION_NONE)

function enfos_shrine_aura:Precache(context)
	print("precache running from shrine aura")
	PrecacheResource("particle", "particles/world_shrine/dire_shrine_regen.vpcf", context)
	PrecacheResource("particle", "particles/world_shrine/radiant_shrine_regen.vpcf", context)

end

function enfos_shrine_aura:GetIntrinsicModifierName()
	return "modifier_enfos_shrine_aura"
end


modifier_enfos_shrine_aura = class({})

function modifier_enfos_shrine_aura:IsPurgable() return false end
function modifier_enfos_shrine_aura:IsHidden() return true end

function modifier_enfos_shrine_aura:IsAura() return true end
function modifier_enfos_shrine_aura:GetAuraRadius() return self.radius or 1800 end
function modifier_enfos_shrine_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_enfos_shrine_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_enfos_shrine_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_enfos_shrine_aura:GetModifierAura() return "modifier_enfos_shrine_aura_effect" end

function modifier_enfos_shrine_aura:GetAuraEntityReject(unit)
	return unit:GetUnitName() == "npc_enfos_wizard"
end

function modifier_enfos_shrine_aura:OnCreated() self:OnRefresh() end

function modifier_enfos_shrine_aura:OnRefresh()
	local ability = self:GetAbility()
	self.radius = ability:GetSpecialValueFor("radius")
end


modifier_enfos_shrine_aura_effect = class({})

function modifier_enfos_shrine_aura_effect:IsPurgable() return false end

function modifier_enfos_shrine_aura_effect:OnCreated()
	self:OnRefresh()
	if not IsServer() then return end

	local parent = self:GetParent()
	local effect_name = self:_GetEffectName()
	local particle = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetOrigin(), true)

	self:AddParticle(particle, false, false, 1, false, false)
end

function modifier_enfos_shrine_aura_effect:OnRefresh()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then self:Destroy() return end
	self.health_regen_pct = ability:GetSpecialValueFor("health_regen_pct")
	self.mana_regen_pct = ability:GetSpecialValueFor("mana_regen_pct")
end

function modifier_enfos_shrine_aura_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, -- GetModifierHealthRegenPercentage
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE, -- GetModifierTotalPercentageManaRegen
	}
end

function modifier_enfos_shrine_aura_effect:GetModifierHealthRegenPercentage()
	return self.health_regen_pct
end

function modifier_enfos_shrine_aura_effect:GetModifierTotalPercentageManaRegen()
	return self.mana_regen_pct
end

function modifier_enfos_shrine_aura_effect:_GetEffectName()
	if self:GetCaster():GetTeam() == DOTA_TEAM_BADGUYS then
		return "particles/world_shrine/dire_shrine_regen.vpcf"
	else
		return "particles/world_shrine/radiant_shrine_regen.vpcf"
	end
end
