creature_avalanche = class({})
LinkLuaModifier( "modifier_creature_avalanche_thinker", "creatures/abilities/regular/creature_avalanche", LUA_MODIFIER_MOTION_NONE )

function creature_avalanche:ProcsMagicStick()
	return false
end

function creature_avalanche:GetChannelAnimation() return ACT_DOTA_CHANNEL_ABILITY_1 end
function creature_avalanche:GetPlaybackRateOverride() return 1 end

function creature_avalanche:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle("particles/creature/storegga_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	end
	return true
end

function creature_avalanche:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nChannelFX, false)
	end
end

function creature_avalanche:OnSpellStart()
	if IsServer() then
		self.flChannelTime = 0.0
		self.hThinker = CreateModifierThinker(self:GetCaster(), self, "modifier_creature_avalanche_thinker", {duration = self:GetChannelTime()}, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false)
	end
end

function creature_avalanche:OnChannelThink(flInterval)
	if IsServer() then
		self.flChannelTime = self.flChannelTime + flInterval
		if self.flChannelTime > 9.2 and self.bStartedGesture ~= true then
			self.bStartedGesture = true
			self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
		end
	end
end

function creature_avalanche:OnChannelFinish( bInterrpted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		if self.hThinker ~= nil and self.hThinker:IsNull() == false then
			self.hThinker:ForceKill( false )
			self:StartCooldown(self:GetSpecialValueFor("end_cooldown"))
		end
	end
end



modifier_creature_avalanche_thinker = class({})

function modifier_creature_avalanche_thinker:IsHidden() return true end
function modifier_creature_avalanche_thinker:IsPurgable() return false end

function modifier_creature_avalanche_thinker:OnCreated(kv)
	if IsServer() then
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.movement = self:GetAbility():GetSpecialValueFor("movement")
		self.current_dir = RandomVector(1)

		self.Avalanches = {}

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		self.hAvalancheTarget = enemies[RandomInt(1, #enemies)]

		if self.hAvalancheTarget then
			self.current_dir = (self.hAvalancheTarget:GetOrigin() - self:GetCaster():GetOrigin()):Normalized()
		end

		self:OnIntervalThink()
		self:StartIntervalThink(self.interval)
	end
end

function modifier_creature_avalanche_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsNull() then
			self:Destroy()
			return
		end

		EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), "BossAvalanche.Smash", self:GetCaster())

		local vNewAvalancheDir1 = self.current_dir:Normalized()
		local vNewAvalancheDir2 = RotatePosition(vNewAvalancheDir1, QAngle(0, 180, 0), vNewAvalancheDir1 * 100):Normalized()
		self.current_dir = RotatePosition(self.current_dir, QAngle(0, 20, 0), self.current_dir * 100):Normalized()

		local vRadius = Vector(self.radius * .72, self.radius * .72, self.radius * .72)
		local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex1, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex1, 1, vRadius )
		ParticleManager:SetParticleControlForward( nFXIndex1, 0, vNewAvalancheDir1 )
		self:AddParticle( nFXIndex1, false, false, -1, false, false )

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex2, 1, vRadius )
		ParticleManager:SetParticleControlForward( nFXIndex2, 0, vNewAvalancheDir2 )
		self:AddParticle( nFXIndex2, false, false, -1, false, false )

		local Avalanche1 = 
		{
			vCurPos = self:GetCaster():GetOrigin(),
			vDir = vNewAvalancheDir1,
			nFX = nFXIndex1,
		}
		local Avalanche2 = 
		{
			vCurPos = self:GetCaster():GetOrigin(),
			vDir = vNewAvalancheDir2,
			nFX = nFXIndex2,
		}
		
		table.insert( self.Avalanches, Avalanche1 )
		table.insert( self.Avalanches, Avalanche2 )

		for _,ava in pairs ( self.Avalanches ) do
			local vNewPos = ava.vCurPos + ava.vDir * self.movement
			ava.vCurPos = vNewPos

			ParticleManager:SetParticleControl( ava.nFX, 0, vNewPos )

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vNewPos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
					local damageInfo = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damageInfo )
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.1})
				end
			end
		end
	end
end
