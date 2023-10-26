LinkLuaModifier( "modifier_health_life_drain", "heroes/hero_pugna/pugna_life_drain/life_drain", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_health_life_drain_now", "heroes/hero_pugna/pugna_life_drain/life_drain", LUA_MODIFIER_MOTION_NONE )

health_life_drain = class({})

function health_life_drain:GetAOERadius()
	return self:GetSpecialValueFor("aura_radius") + self:GetCaster():GetCastRangeBonus()
end

function health_life_drain:GetBehavior()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_pugna_str50") then
		return DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_AURA
end

function health_life_drain:GetIntrinsicModifierName()
	return "modifier_health_life_drain"
end

---------------------------------------------------------------------------------------

modifier_health_life_drain = class({})

function modifier_health_life_drain:IsHidden()
	return true
end

function modifier_health_life_drain:IsPurgable()
	return false
end

function modifier_health_life_drain:OnCreated( kv )
	self.find = self:GetAbility():GetSpecialValueFor( "find_interval" )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_str10")	
	if abil ~= nil then 
		self.find = self:GetAbility():GetSpecialValueFor( "find_interval" ) - 0.7
	end
	
	self:StartIntervalThink(self.find)
end

function modifier_health_life_drain:OnIntervalThink()
	if not IsServer() then return end
	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor( "aura_radius" ), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	for _,unit in pairs(targets) do
		if unit ~= self:GetCaster() then
			if not unit:HasModifier("modifier_health_life_drain_now") then
				unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_health_life_drain_now", {})
				EmitSoundOn("Hero_Pugna.LifeDrain.Cast", self:GetCaster())
				break
			end
		end
	end
	self.find = self:GetAbility():GetSpecialValueFor( "find_interval" )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_str10")	
	if abil ~= nil then 
		self.find = self:GetAbility():GetSpecialValueFor( "find_interval" ) - 0.7
	end
	
	self:StartIntervalThink(-1)
	self:StartIntervalThink(self.find)
end

-----------------------------------------------------------------------------------------

modifier_health_life_drain_now = class({})

function modifier_health_life_drain_now:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_health_life_drain_now:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_target = "Hero_Pugna.LifeDrain.Target"
	self.sound_loop = "Hero_Pugna.LifeDrain.Loop"
	self.particle_drain = "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf"
	self.particle_give = "particles/units/heroes/hero_pugna/pugna_life_give.vpcf"

	self.aura_damage_interval = self.ability:GetSpecialValueFor("aura_damage_interval")
	self.radius = self.ability:GetSpecialValueFor("aura_radius")

	if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
		self.is_ally = true
	else
		self.is_ally = false
	end

	if IsServer() then
		-- EmitSoundOn(self.sound_target, self.parent)
		-- StopSoundOn(self.sound_loop, self.parent)
		-- EmitSoundOn(self.sound_loop, self.parent)
	
		if self.is_ally then
			self.particle_drain_fx = ParticleManager:CreateParticle(self.particle_give, PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		else
			self.particle_drain_fx = ParticleManager:CreateParticle(self.particle_drain, PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		end
	
		self.radius = self.radius + self:GetCaster():GetCastRangeBonus()

		Timers:CreateTimer(self.aura_damage_interval, function()
			self:StartIntervalThink(self.aura_damage_interval)
		end)
	else
		self:StartIntervalThink(self.aura_damage_interval)
	end
end

function modifier_health_life_drain_now:OnIntervalThink()
	if IsServer() then
		if self.parent:IsIllusion() and self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() and not Custom_bIsStrongIllusion(self.parent) then
			self.parent:Kill(self.ability, self.caster)
			return nil
		end

		if self.caster:IsSilenced() then
			self:Destroy()
		end

		if self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() and self.parent:IsInvisible() then
			self:Destroy()
		end

		if not self.caster:CanEntityBeSeenByMyTeam(self.parent) or self.parent:IsInvulnerable() or self.parent:IsMagicImmune() then
			self:Destroy()
		end

		local distance = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()

		if distance > self.radius + 100 then
			self:Destroy()
		end

		if not self.caster:IsAlive() then
			self:Destroy()
		end
		
		self.aura_damage = self.ability:GetSpecialValueFor("aura_damage")
		
		local abil = self.caster:FindAbilityByName("npc_dota_hero_pugna_int_last")	
		if abil ~= nil then 
			self.aura_damage = self.aura_damage * 2
		end	
		
		if self.parent:IsAncient() then	
			self.aura_damage = self.aura_damage / 4
		end
		
		local damage = self.parent:GetHealth()/100 * self.aura_damage * self.aura_damage_interval

		damage_type = DAMAGE_TYPE_PURE
		if self:GetAbility():GetBehavior() == DOTA_ABILITY_BEHAVIOR_TOGGLE then
			if self:GetAbility():GetToggleState() then
				damage_type = DAMAGE_TYPE_PURE
			else
				damage_type = DAMAGE_TYPE_MAGICAL
			end
		end
		if self.is_ally then
			local damageTable = {victim = self.caster,
				damage = damage,
				damage_type = damage_type,
				attacker = self.caster,
				ability = self.ability,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
			}

			local actual_damage = ApplyDamage(damageTable)

			local missing_health = self.parent:GetMaxHealth() - self.parent:GetHealth()

			self.parent:Heal(actual_damage, self.caster)
		else
			local damageTable = {victim = self.parent,
				damage = damage,
				damage_type = damage_type,
				attacker = self.caster,
				ability = self.ability,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
			}

			local actual_damage = ApplyDamage(damageTable)

			local missing_health = self.caster:GetMaxHealth() - self.caster:GetHealth()
			
			self.caster:Heal(actual_damage, self.caster)
		end
	end
end

function modifier_health_life_drain_now:CheckState()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return {
			[MODIFIER_STATE_PROVIDES_VISION]	= true,
			[MODIFIER_STATE_INVISIBLE]			= false
		}
	end
end

function modifier_health_life_drain_now:IsHidden() return true end
function modifier_health_life_drain_now:IsPurgable() return false end
function modifier_health_life_drain_now:IsDebuff()
	if self.is_ally then
		return false
	else
		return true
	end
end

function modifier_health_life_drain_now:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.particle_drain_fx, false)
	ParticleManager:ReleaseParticleIndex(self.particle_drain_fx)
end


function modifier_health_life_drain_now:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_health_life_drain_now:GetModifierMoveSpeedBonus_Percentage()
	if self.is_ally then
		return nil
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_str11")	
	if abil ~= nil then 
		return -50
	end
	return 0
end

function modifier_health_life_drain_now:GetModifierIncomingDamage_Percentage(keys)
if not IsServer() then return end
    if keys.damage_type == DAMAGE_TYPE_MAGICAL or keys.damage_type == DAMAGE_TYPE_PURE then
		if self.is_ally then
			return nil
		end
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_str11")	
		if abil ~= nil then 
			return 25
		end
		return 0
	end	
end
-- function HeartstopperAura( keys )
	-- local caster = keys.caster
	-- local ability = keys.ability
	-- local target = keys.target
	-- local aura_damage_interval = ability:GetLevelSpecialValueFor("aura_damage_interval", (ability:GetLevel() - 1))
	-- local aura_damage = target:GetHealth() * (ability:GetLevelSpecialValueFor("aura_damage", (ability:GetLevel() - 1)) * 0.01)
	
	-- local abil = caster:FindAbilityByName("npc_dota_hero_pugna_str10")	
		-- if abil ~= nil then 
		-- aura_damage = target:GetHealth() * (ability:GetLevelSpecialValueFor("aura_damage", (ability:GetLevel() - 1)) * 0.01) * 2
		-- end
	-- local abil = caster:FindAbilityByName("npc_dota_hero_pugna_int_last")	
		-- if abil ~= nil then 
		-- aura_damage = aura_damage * 2
		-- end	
		-- if target:IsAncient() then	
		-- aura_damage = aura_damage / 4
		-- end
		
	-- local damage_table = {}
	-- damage_table.attacker = caster
	-- damage_table.victim = target
	-- damage_table.damage_type = DAMAGE_TYPE_PURE
	-- damage_table.ability = ability
	-- damage_table.damage = aura_damage * aura_damage_interval
	-- damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	-- ApplyDamage(damage_table)
	
	-- local abil = caster:FindAbilityByName("npc_dota_hero_pugna_str11")	
	-- if abil == nil then 
		-- caster:Heal(aura_damage * aura_damage_interval, keys.caster)	
	-- end
	
	-- local abil = caster:FindAbilityByName("npc_dota_hero_pugna_str11")	
	-- if abil ~= nil then 
	-- local nearby_allied_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, 700,	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)	
		-- for i, nearby_ally in ipairs(nearby_allied_units) do
			-- nearby_ally:Heal(aura_damage * aura_damage_interval, keys.caster)	
		-- end
	-- end
-- end

