require("heroes/hero_enigma/eidolons")

enigma_malefice = class({})
LinkLuaModifier("modifier_enigma_malefice_custom", "heroes/hero_enigma/enigma_malefice.lua", LUA_MODIFIER_MOTION_NONE)

function enigma_malefice:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if not caster or caster:IsNull() then return end
	if not target or target:IsNull() then return end

	if target:TriggerSpellAbsorb( self ) then return end

	local stun_instances = self:GetSpecialValueFor("stun_instances")
	local tick_rate = self:GetSpecialValueFor("tick_rate")
	local duration = tick_rate * (stun_instances - 1)	-- first stun instance is immediate

	target:AddNewModifier(caster, self, "modifier_enigma_malefice_custom", { duration = duration })
	EmitSoundOn( "Hero_Enigma.Malefice", target )
end

---@param unit CDOTA_BaseNPC
function enigma_malefice:UpgradeEidolon(unit)
	if IsValidEntity(unit) and unit:IsAlive() then
		unit:SetBaseDamageMin(unit:GetBaseDamageMin() + unit.original_base_min_attack)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax() + unit.original_base_max_attack)

		unit.original_damage_min = unit:GetBaseDamageMin()
		unit.original_damage_max = unit:GetBaseDamageMax()

		unit.multicast = unit.multicast and unit.multicast + 1 or 2

		-- Update summon buff values
		local modifier_summon_buff = unit:FindModifierByName("modifier_summon_buff")
		if modifier_summon_buff then 
			modifier_summon_buff.original_base_health = unit.original_base_max_health * unit.multicast
			modifier_summon_buff:ForceRefresh()
		end

		local particle_name = "particles/units/heroes/hero_ursa/ursa_overpower_cast.vpcf"
		local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:ReleaseParticleIndex(pfx)

		local modifier = unit:AddNewModifier(unit, nil, "modifier_multicast_grow", nil)
		if modifier then
			modifier:SetStackCount(unit.multicast)
		end
	end
end


--------------------------------------------------------------------------------------------------------------------------------------------------------


modifier_enigma_malefice_custom = class({})

function modifier_enigma_malefice_custom:IsHidden() return false end
function modifier_enigma_malefice_custom:IsDebuff() return true end
function modifier_enigma_malefice_custom:IsStunDebuff() return false end
function modifier_enigma_malefice_custom:IsPurgable() return true end

function modifier_enigma_malefice_custom:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	if not self.caster or self.caster:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end
	
	self.tick_rate = self.ability:GetSpecialValueFor( "tick_rate" )
	self.damage = self.ability:GetSpecialValueFor( "damage" )
	self.stun_duration = self.ability:GetSpecialValueFor( "stun_duration" )
	
	if not IsServer() then return end

	self.damage_table = {
		victim = self.parent,
		attacker = self.caster,
		damage = self.damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability,
	}

	self:StartIntervalThink(self.tick_rate)
	self:OnIntervalThink()
end

function modifier_enigma_malefice_custom:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_enigma_malefice_custom:OnIntervalThink()
	self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", { duration = self.stun_duration })
	ApplyDamage( self.damage_table )
	EmitSoundOn( "Hero_Enigma.MaleficeTick", self:GetParent() )
	if not self.caster:HasShard() then return end

	if not IsValidEntity(self.eidolon) or not self.eidolon:IsAlive() then
		local duration = self.ability:GetSpecialValueFor("eidolon_duration")
		self.eidolon = SpawnEidolon(self.ability, self.caster, self.parent:GetAbsOrigin(), duration, 1, 1, false, true)
	else
		self.ability:UpgradeEidolon(self.eidolon)
	end
end

function modifier_enigma_malefice_custom:GetEffectName()
	return "particles/units/heroes/hero_enigma/enigma_malefice.vpcf"
end

function modifier_enigma_malefice_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_enigma_malefice_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_enigma_malefice.vpcf"
end

function modifier_enigma_malefice_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end

function modifier_enigma_malefice_custom:OnTooltip()
	return self.damage
end

function modifier_enigma_malefice_custom:OnTooltip2()
	return self.stun_duration
end

