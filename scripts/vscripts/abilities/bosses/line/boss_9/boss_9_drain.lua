LinkLuaModifier("modifier_boss_9_drain", "abilities/bosses/line/boss_9/boss_9_drain", LUA_MODIFIER_MOTION_NONE)

boss_9_drain = class({})

function boss_9_drain:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		if #enemies > 0 then
			EmitSoundOn("Hero_Pugna.LifeDrain.Cast", caster)
			for _, enemy in pairs( enemies ) do
			enemy:AddNewModifier(caster, ability, "modifier_boss_9_drain", {duration = 6})
		end
	end
end


modifier_boss_9_drain = class({})

function modifier_boss_9_drain:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_boss_9_drain:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_target = "Hero_Pugna.LifeDrain.Target"
	self.sound_loop = "Hero_Pugna.LifeDrain.Loop"
	self.particle_drain = "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf"
	self.particle_give = "particles/units/heroes/hero_pugna/pugna_life_give.vpcf"
	self.nether_ward = "npc_imba_pugna_nether_ward"

	self.health_drain = 5
	self.tick_rate = 0.25
	self.break_distance_extend = 400

	if IsServer() then
		EmitSoundOn(self.sound_target, self.parent)

		StopSoundOn(self.sound_loop, self.parent)
		EmitSoundOn(self.sound_loop, self.parent)
	

		self.particle_drain_fx = ParticleManager:CreateParticle(self.particle_give, PATTACH_ABSORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)

		self.break_distance_extend = self.break_distance_extend + self:GetCaster():GetCastRangeBonus()

		Timers:CreateTimer(self.tick_rate, function()
			self:StartIntervalThink(self.tick_rate)
		end)
	else
		self:StartIntervalThink(self.tick_rate)
	end
end

function modifier_boss_9_drain:OnIntervalThink()
	if IsServer() then
		if self.parent:IsIllusion() and self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() and not Custom_bIsStrongIllusion(self.parent) then
			self.parent:Kill(self.ability, self.caster)
			return nil
		end

		if self.caster:IsStunned() or self.caster:IsSilenced() then
			self:Destroy()
		end

		if self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() and self.parent:IsInvisible() then
			self:Destroy()
		end

		if not self.caster:CanEntityBeSeenByMyTeam(self.parent) or self.parent:IsInvulnerable() or self.parent:IsMagicImmune() then
			self:Destroy()
		end

		local cast_range = self.ability:GetCastRange(self.caster:GetAbsOrigin(), self.parent)
		local distance = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()

		
		if distance > (cast_range + self.break_distance_extend) then
			self:Destroy()
		end


		if not self.caster:IsAlive() then
			self:Destroy()
		end
		
		local damage = (self.health_drain * 0.05 * self.parent:GetHealth()) * self.tick_rate

		local damageTable = {victim = self.parent,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			attacker = self.caster,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self.ability
		}

		local actual_damage = ApplyDamage(damageTable)

		self.caster:Heal(actual_damage, self.caster)
	end
end

function modifier_boss_9_drain:CheckState()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return {
			[MODIFIER_STATE_PROVIDES_VISION]	= true,
			[MODIFIER_STATE_INVISIBLE]			= false
		}
	end
end

function modifier_boss_9_drain:IsHidden() return true end
function modifier_boss_9_drain:IsPurgable() return false end
function modifier_boss_9_drain:IsDebuff()
	if self.is_ally then
		return false
	else
		return true
	end
end

function modifier_boss_9_drain:OnDestroy()
	if not IsServer() then return end
	
	ParticleManager:DestroyParticle(self.particle_drain_fx, false)
	ParticleManager:ReleaseParticleIndex(self.particle_drain_fx)

	-- Stop sounds
	StopSoundOn(self.sound_target, self.parent)
	StopSoundOn(self.sound_loop, self.parent)
end
