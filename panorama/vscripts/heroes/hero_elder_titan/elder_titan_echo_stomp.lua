elder_titan_echo_stomp_lua = class({})

function elder_titan_echo_stomp_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cast_combined.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", context )
end

function elder_titan_echo_stomp_lua:GetAbilityTextureName()
	if self:GetCaster():GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" then
		return "elder_titan_echo_stomp_spirit"
	end
	return "elder_titan_echo_stomp"
end

function elder_titan_echo_stomp_lua:GetBehavior()
	if self:GetCaster():HasShard() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end

	return self.BaseClass.GetBehavior(self)
end

function elder_titan_echo_stomp_lua:OnAbilityPhaseStart()
	if not IsServer() then return end

	self.caster = self:GetCaster()
	if not self.caster or self.caster:IsNull() then return end

	self.owner = self.caster
	if self.caster:GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" then
		self.owner = self.caster:GetOwner()
		self.ancestral_spirit = self.caster
	end
	if not self.owner or self.owner:IsNull() then return end

	

	-- since both the spirit and the hero have the same spell then we decide if the hero or spirit cast
	local echo_stomp = self.owner:FindAbilityByName(self:GetAbilityName())
	if self.caster == self.ancestral_spirit then
		if echo_stomp and not echo_stomp:IsNull() and not echo_stomp:IsInAbilityPhase() then
			if echo_stomp:IsFullyCastable() then	-- if the hero is disabled from casting, do nothing
				self.owner:CastAbilityNoTarget(echo_stomp, self.owner:GetPlayerOwnerID())
			else
				return false
			end
		end
		return true
	end

	-- multicast only for hero
	local multicast_modifier = self.caster:FindModifierByName("modifier_multicast_lua")
	self.multicast = 1
	
	if multicast_modifier then
		self.multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(self.multicast)
	end
	
	-- Fetch the spirit
	-- if the hero casts then tell the spirit to cast as well
	local ancestral_spirit_ability = self.caster:FindAbilityByName("elder_titan_ancestral_spirit_lua")
	if ancestral_spirit_ability and not ancestral_spirit_ability:IsNull() then
		self.ancestral_spirit = ancestral_spirit_ability:GetAncestralSpirit()		-- does not exist if the caster is the spirit itself
		if self.ancestral_spirit and not self.ancestral_spirit:IsNull() and IsValidEntity(self.ancestral_spirit) then
			local ancestral_spirit_echo_stomp = self.ancestral_spirit:FindAbilityByName(self:GetAbilityName())
			if ancestral_spirit_echo_stomp and not ancestral_spirit_echo_stomp:IsNull() and not ancestral_spirit_echo_stomp:IsInAbilityPhase() then
				-- sometimes spirit does not cast so we need a timer smh
				Timers:CreateTimer(0.01, function()
					if self and self.ancestral_spirit and IsValidEntity(self.ancestral_spirit) and ancestral_spirit_echo_stomp then
						ancestral_spirit_echo_stomp:SetMulticastLevel(echo_stomp:GetMulticastLevel())
						self.ancestral_spirit:CastAbilityNoTarget(ancestral_spirit_echo_stomp, self.ancestral_spirit:GetPlayerOwnerID())
					end
				end)
			end
			return true
		end
	end

	-- Combined particle only if ancestral spirit not cast
	self.particle_echo_stomp_cast_combined = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cast_combined.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	return true
end

function elder_titan_echo_stomp_lua:OnAbilityPhaseInterrupted()
	if not IsServer() then return end
	if not self.caster or self.caster:IsNull() then return end
	if not self.owner or self.owner:IsNull() then return end
	self.caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)

	if self.particle_echo_stomp_cast_combined then
		ParticleManager:DestroyParticle(self.particle_echo_stomp_cast_combined, true)
		ParticleManager:ReleaseParticleIndex(self.particle_echo_stomp_cast_combined)
		self.particle_echo_stomp_cast_combined = nil
	end

	if self.caster == self.ancestral_spirit then
		self.owner:Interrupt()
		return
	else
		if self.ancestral_spirit and not self.ancestral_spirit:IsNull() and IsValidEntity(self.ancestral_spirit) then -- if caster is not a spirit, but a spirit exists
			self.ancestral_spirit:Interrupt()
		end
	end
end

function elder_titan_echo_stomp_lua:OnSpellStart()
	if not IsServer() then return end
	self.radius = self:GetSpecialValueFor("radius") or 0
	self.sleep_duration = self:GetSpecialValueFor("sleep_duration") or 0
	local stomp_damage = self:GetSpecialValueFor("stomp_damage") or 0

	self.damage_table = {
		attacker 		= self.owner,
		ability 		= self,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		damage 			= stomp_damage,
	}

	EmitSoundOn("Hero_ElderTitan.EchoStomp.Channel", self.caster)
end

function elder_titan_echo_stomp_lua:OnChannelFinish(interrupted)
	if not IsServer() then return end
	if not self.caster or self.caster:IsNull() then return end

	if self.particle_echo_stomp_cast_combined then
		ParticleManager:DestroyParticle(self.particle_echo_stomp_cast_combined, true)
		ParticleManager:ReleaseParticleIndex(self.particle_echo_stomp_cast_combined)
		self.particle_echo_stomp_cast_combined = nil
	end

	if self.caster == self.ancestral_spirit then
		self:EndCooldown()
		self:RefundManaCost()

		if interrupted then
			self.owner:Interrupt()
			return
		end
	elseif interrupted then
		if self.ancestral_spirit and not self.ancestral_spirit:IsNull() and IsValidEntity(self.ancestral_spirit) then -- if caster is not a spirit, but a spirit exists
			self.ancestral_spirit:Interrupt()
		end
		return
	end

	local delay = 0.5
	-- create thinker for multicast
	for i = 0, self.multicast - 1, 1 do
		Timers:CreateTimer(delay * i, function()
			if self.caster and self and IsValidEntity(self.caster) and IsValidEntity(self) then
				
				EmitSoundOn("Hero_ElderTitan.EchoStomp", self.caster)
	
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				for _, enemy in pairs(enemies) do
					-- split the damage into physical and magical components
					-- since both the spirit and the hero have the same spell then we decide if the hero casts both or if it is split among them
					self.damage_table.victim = enemy
					if self.caster == self.ancestral_spirit then
						-- spirit only casts magical dmg
						self.damage_table.damage_type = DAMAGE_TYPE_MAGICAL
						ApplyDamage(self.damage_table)
					else
						-- heroes cast both only if spirit does not exist
						self.damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
						ApplyDamage(self.damage_table)
						if not self.ancestral_spirit then
							self.damage_table.damage_type = DAMAGE_TYPE_MAGICAL
							ApplyDamage(self.damage_table)
						end
					end

					enemy:AddNewModifier(self.caster, self, "modifier_elder_titan_echo_stomp", {duration = self.sleep_duration * (1 - enemy:GetStatusResistance())})
				end

				-- Particles
				-- Magical component, always goes off on the spirit; goes off on the hero only if spirit does not exist
				if (self.caster == self.ancestral_spirit) or (self.caster ~= self.ancestral_spirit and not self.ancestral_spirit) then
					local particle_magical_stomp_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", PATTACH_ABSORIGIN, self.caster)
					ParticleManager:SetParticleControl(particle_magical_stomp_fx, 1, Vector(self.radius, 1, 1))
					ParticleManager:SetParticleControl(particle_magical_stomp_fx, 2, self.caster:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle_magical_stomp_fx)
				end
				
				if self.caster == self.ancestral_spirit then return end

				-- Particles
				-- Physical component only goes off on the hero
				local particle_physical_stomp_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_ABSORIGIN, self.caster)
				ParticleManager:SetParticleControl(particle_physical_stomp_fx, 0, self.caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_physical_stomp_fx, 1, Vector(self.radius, 1, 1))
				ParticleManager:SetParticleControl(particle_physical_stomp_fx, 2, self.caster:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_physical_stomp_fx)

				return
			end
		end)
	end

	-- Shard effect
	if not self.caster:HasShard() then return end
	if not self:GetAutoCastState() then return end

	if self.ancestral_spirit and not self.ancestral_spirit:IsNull() and IsValidEntity(self.ancestral_spirit) then
		self.caster:SetOrigin(self.ancestral_spirit:GetAbsOrigin())
	end
end

-- used to transfer the multicast factor from hero to spirit
function elder_titan_echo_stomp_lua:SetMulticastLevel(level)
	self.multicast = level
end

function elder_titan_echo_stomp_lua:GetMulticastLevel()
	return self.multicast
end
