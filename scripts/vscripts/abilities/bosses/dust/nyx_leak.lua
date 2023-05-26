LinkLuaModifier("modifier_nyx_leak", "abilities/bosses/dust/nyx_leak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nyx_leak_aura", "abilities/bosses/dust/nyx_leak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nyx_leak_delay", "abilities/bosses/dust/nyx_leak", LUA_MODIFIER_MOTION_NONE)

nyx_leak = class({})

function nyx_leak:GetIntrinsicModifierName()
	return "modifier_nyx_leak_aura"
end

---------------------------------------------

modifier_nyx_leak_aura = class({})

function modifier_nyx_leak_aura:IsHidden()
	return true
end

function modifier_nyx_leak_aura:IsDebuff()
	return false
end

function modifier_nyx_leak_aura:IsPurgable()
	return false
end

function modifier_nyx_leak_aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_nyx_leak_aura:GetModifierAura()
	return "modifier_nyx_leak"
end

function modifier_nyx_leak_aura:GetAuraRadius()
	return 1000
end

function modifier_nyx_leak_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_nyx_leak_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

---------------------------------------------
modifier_nyx_leak_delay = class({})

function modifier_nyx_leak_delay:IsHidden()
	return true
end

function modifier_nyx_leak_delay:IsPurgable()
	return false
end
---------------------------------------------

modifier_nyx_leak = class({})

function modifier_nyx_leak:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()

	self.mana_leak_pct	= self.ability:GetSpecialValueFor("mana")
	self.stun_duration	= self.ability:GetSpecialValueFor("stun")
	
	if not IsServer() then return end
	
	
	if self.parent:GetMaxMana() <= 0 and not self.parent:HasModifier("modifier_nyx_leak_delay") then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stun_duration * (1 - self.parent:GetStatusResistance())})
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_nyx_leak_delay", {duration = 5})
		self:Destroy()
	else
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:ReleaseParticleIndex(particle)
		self:StartIntervalThink(0.1)
	end
end

function modifier_nyx_leak:OnRefresh()
	self:OnCreated()
end

function modifier_nyx_leak:OnIntervalThink()
	if not IsServer() then return end
	local new_position = self.parent:GetAbsOrigin()
	local max_mana = self.parent:GetMaxMana()
	

	self.parent:Script_ReduceMana(max_mana * self.mana_leak_pct * 0.01, nil)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:ReleaseParticleIndex(particle)
	
	if self.parent:GetMana() <= 0 and not self.parent:HasModifier("modifier_nyx_leak_delay") then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stun_duration * (1 - self.parent:GetStatusResistance())})
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_nyx_leak_delay", {duration = 5})
		self:Destroy()
	end
end

function modifier_nyx_leak:OnDestroy()
	if not IsServer() then return end
	self.parent:StopSound("Imba.Hero_KeeperOfTheLight.ManaLeak.Target.FP")
end