---@class modifier_undying_tombstone_lua:CDOTA_Modifier_Lua
modifier_undying_tombstone_lua = class({})

function modifier_undying_tombstone_lua:IsHidden() return true end
function modifier_undying_tombstone_lua:IsPurgable() return false end

function modifier_undying_tombstone_lua:IsAura() return true end
function modifier_undying_tombstone_lua:GetModifierAura() return "modifier_undying_tombstone_debuff_lua" end
function modifier_undying_tombstone_lua:GetAuraDuration() return 0.1 end
function modifier_undying_tombstone_lua:GetAuraRadius() return self.radius end

function modifier_undying_tombstone_lua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_undying_tombstone_lua:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_undying_tombstone_lua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NO_INVIS end

function modifier_undying_tombstone_lua:GetAuraEntityReject(entity)
	self.targets[entity] = true
end

function modifier_undying_tombstone_lua:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end

function modifier_undying_tombstone_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end


function modifier_undying_tombstone_lua:OnCreated()
	if not IsServer() then return end

	self.ability = self:GetAbility()
	if not self.ability or self.ability:IsNull() then return end

	self.parent = self:GetParent()
	if not self.parent or self.parent:IsNull() then return end

	self.caster = self:GetCaster()
	if not self.caster or self.caster:IsNull() then return end

	self.agility_multiplier = self.ability:GetSpecialValueFor("agility_multiplier")
	self.radius 	= self.ability:GetSpecialValueFor("radius")
	self.interval 	= self.ability:GetSpecialValueFor("proc_interval")
	self.debuff_duration = self.ability:GetSpecialValueFor("slow_duration")

	self.targets = {}
	
	-- special tombstone summon property instead of attack speed increase which does nothing
	local agi = self.caster:GetAgility() or 0
	self.interval = self.interval / (1 + self.agility_multiplier * agi)

	self:StartIntervalThink(self.interval)

	--First attack immediately after spawn
	Timers:CreateTimer(0.01, function()
		self:OnIntervalThink()
	end)
end


function modifier_undying_tombstone_lua:OnIntervalThink()
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end
	if not self.caster or self.caster:IsNull() then return end

	if self.parent:IsStunned() then return end

	local particle = ParticleManager:CreateParticle("particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay_smoke_swirl.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())	
	ParticleManager:SetParticleControl(particle, 1, Vector( self.radius, 0, 0 ))
	ParticleManager:ReleaseParticleIndex(particle)

	self.parent:EmitSound("Tombstone.RaiseDead")

	for target, _ in pairs(self.targets) do

		local remove = true

		if IsValidEntity(target) then
			local aura_debuffs = target:FindAllModifiersByName("modifier_undying_tombstone_debuff_lua")
			
			for _, debuff in pairs(aura_debuffs) do
				if debuff:GetAuraOwner() == self.parent then
					debuff:OnIntervalThink()
					remove = false
				end
			end
		end

		if remove then
			self.targets[target] = nil
		end
	end
end

function modifier_undying_tombstone_lua:GetModifierAvoidDamage(params)
	local parent = self:GetParent()
	local health = parent:GetHealth()

	if params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then 
		return 1
	end

	local damage = params.attacker:IsRealHero() and 8 or 1

	if health > damage then
		parent:SetHealth(health - damage)
	else
		parent:Kill(nil, params.attacker)
	end

	return 1
end

function modifier_undying_tombstone_lua:GetDisableHealing()
	return 1
end



modifier_undying_tombstone_debuff_lua = class({})

function modifier_undying_tombstone_debuff_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_undying_tombstone_debuff_lua:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()

	self.per_stack = self.ability:GetSpecialValueFor("per_stack_slow")

	if IsClient() then return end

	local tombstone = self:GetAuraOwner()

	if not tombstone then 
		self:Destroy() 
		return
	end

	self.origin = tombstone:GetAbsOrigin()
	self.hitloc = tombstone:GetAttachmentOrigin( tombstone:ScriptLookupAttachment("attach_hitloc") )
	self.hitloc.z = self.origin.z + 100
end

-- Called from modifier_undying_tombstone_lua:OnIntervalThink
function modifier_undying_tombstone_debuff_lua:OnIntervalThink()
	local tombstone = self:GetAuraOwner()
	local parent = self:GetParent()

	if not parent:IsAttackImmune() then
		local evasion = parent:GetEvasion() * 100
		if not RollPercentage(evasion) then
			
			self:IncrementStackCount()

			local total_damage = ApplyDamage({
				damage 			= tombstone:GetAverageTrueAttackDamage(tombstone) * self:GetStackCount(),
				damage_type		= DAMAGE_TYPE_PHYSICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
				attacker 		= tombstone,
				victim 			= parent,
				ability 		= self.ability,
			})

			-- Tombstone is special case for Soul Link, because it is considered attack, while technically not
			local soul_link_mod = self.caster:FindModifierByName("modifier_innate_soul_link_buff")
			if soul_link_mod then
				self.caster:Heal(total_damage * soul_link_mod.creep_lifesteal, soul_link_mod.ability)

				local lifesteal_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(lifesteal_pfx, 1, parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
			end

			-- Tombstone special case for Brawler
			local brawler_mod = parent:FindModifierByName("modifier_innate_brawler")
			if brawler_mod then
				brawler_mod:OnAbilityExceptionHit()
			end
			
			local parent_loc = parent:GetAbsOrigin()
			local drain_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf", PATTACH_ABSORIGIN, parent)
			ParticleManager:SetParticleControl(drain_pfx, 0, parent_loc)
			ParticleManager:SetParticleControl(drain_pfx, 1, self.hitloc)
			ParticleManager:SetParticleControl(drain_pfx, 2, parent_loc)
			ParticleManager:ReleaseParticleIndex(drain_pfx)
		else
			local evade_pfx = ParticleManager:CreateParticle("particles/msg_fx/msg_evade.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
			ParticleManager:SetParticleControl(evade_pfx, 1, Vector(396, 0, 0 ))
			ParticleManager:SetParticleControl(evade_pfx, 2, Vector(1, 3, 0 ))
			ParticleManager:SetParticleControl(evade_pfx, 3, Vector(255,255,255))
			ParticleManager:ReleaseParticleIndex(evade_pfx)
		end
	end
end

function modifier_undying_tombstone_debuff_lua:OnStackCountChanged()
	-- default to -7 in case per_stack is undefined even after calling OnRefresh above
	-- (usually means someone retrained Tomb while it was active and it no longer supplies ability into AddNewModifier)
	self.slow = (self.per_stack or -7) * self:GetStackCount()
end


function modifier_undying_tombstone_debuff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end


function modifier_undying_tombstone_debuff_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end
