boss_eruption = class({})
LinkLuaModifier("modifier_boss_eruption_thinker", "creatures/abilities/boss/boss_eruption", LUA_MODIFIER_MOTION_NONE )

function boss_eruption:GetChannelAnimation() return ACT_DOTA_TELEPORT end
function boss_eruption:GetPlaybackRateOverride() return 1 end

function boss_eruption:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle("particles/creature/storegga_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	end
	return true
end

function boss_eruption:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nChannelFX, false)
	end
end

function boss_eruption:OnSpellStart()
	if IsServer() then
		self.flChannelTime = 0.0
		self.hThinker = CreateModifierThinker(self:GetCaster(), self, "modifier_boss_eruption_thinker", {duration = self:GetChannelTime()}, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false)
	end
end

function boss_eruption:OnChannelThink(flInterval)
	if IsServer() then
		self.flChannelTime = self.flChannelTime + flInterval
		if self.flChannelTime > 6.2 and self.bStartedGesture ~= true then
			self.bStartedGesture = true
			self:GetCaster():StartGesture(ACT_DOTA_RATTLETRAP_HOOKSHOT_END)
		end
	end
end

function boss_eruption:OnChannelFinish( bInterrpted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false)
		if self.hThinker ~= nil and self.hThinker:IsNull() == false then
			self.hThinker:ForceKill( false )
			self:StartCooldown(self:GetSpecialValueFor("end_cooldown"))
		end
	end
end



modifier_boss_eruption_thinker = class({})

function modifier_boss_eruption_thinker:IsHidden() return true end
function modifier_boss_eruption_thinker:IsPurgable() return false end

function modifier_boss_eruption_thinker:OnCreated(kv)
	if IsServer() then
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.delay = self:GetAbility():GetSpecialValueFor("delay")

		if self:GetCaster().spawn_team and GameMode.arena_centers[self:GetCaster().spawn_team] then
			self.arena_center = GameMode.arena_centers[self:GetCaster().spawn_team]

			if GameMode:IsSoloMap() then
				self.max_x = 800
				self.max_y = 800
			elseif GetMapName() == "duos" then
				self.max_x = 1100
				self.max_y = 800
			end
		else
			return nil
		end

		self:OnIntervalThink()
		self:StartIntervalThink(self.interval)
	end
end

function modifier_boss_eruption_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsNull() then
			self:Destroy()
			return
		end

		local sunstrike_loc = self.arena_center + Vector(RandomInt(-self.max_x, self.max_x), RandomInt(-self.max_y, self.max_y), 0)
		local caster = self:GetCaster()
		local radius = self.radius
		local damage = self.damage

		EmitSoundOnLocationWithCaster(sunstrike_loc, "BossEruption.Beam", self:GetCaster())

		local sunstrike_beam = ParticleManager:CreateParticle("particles/creature/boss_eruption_beam.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(sunstrike_beam, 0, sunstrike_loc)
		ParticleManager:SetParticleControl(sunstrike_beam, 1, Vector(self.radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(sunstrike_beam)

		Timers:CreateTimer(self.delay, function()

			if not caster:IsNull() then
				EmitSoundOnLocationWithCaster(sunstrike_loc, "BossEruption.Blast", caster)

				local sunstrike_blast = ParticleManager:CreateParticle("particles/creature/boss_eruption_blast.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(sunstrike_blast, 0, sunstrike_loc)
				ParticleManager:SetParticleControl(sunstrike_blast, 1, Vector(radius, 0, 0))
				ParticleManager:ReleaseParticleIndex(sunstrike_blast)

				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), sunstrike_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _, enemy in pairs(enemies) do
					ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
				end
			end
		end)
	end
end
