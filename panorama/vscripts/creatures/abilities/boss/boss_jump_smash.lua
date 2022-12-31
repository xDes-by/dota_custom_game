LinkLuaModifier("modifier_creature_command_restricted", "creatures/abilities/boss/boss_jump_smash", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_jump_smash_thinker", "creatures/abilities/boss/boss_jump_smash", LUA_MODIFIER_MOTION_NONE)

boss_jump_smash = class({})

function boss_jump_smash:ProcsMagicStick()
	return false
end

function boss_jump_smash:GetPlaybackRateOverride()
	return 0.4 * self:GetSpecialValueFor("jump_speed")
end

function boss_jump_smash:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creature_command_restricted", {duration=self:GetSpecialValueFor( "jump_speed")})
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_jump_smash_thinker", { duration = self:GetSpecialValueFor( "jump_speed") }, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end



modifier_boss_jump_smash_thinker = class({})

function modifier_boss_jump_smash_thinker:OnCreated( kv )
	if IsServer() then
		self.impact_radius = self:GetAbility():GetSpecialValueFor("impact_radius")
		self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")

		self:StartIntervalThink( 0.01 )
	end
end

function modifier_boss_jump_smash_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false or self:GetCaster():IsStunned() then
			UTIL_Remove( self:GetParent() )
			return -1
		end
	end
end

function modifier_boss_jump_smash_thinker:OnDestroy()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "BossSmash.Land", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle("particles/creature/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
					if enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn("BossSmash.Splatter", enemy )
					else
						enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration * (1 - enemy:GetStatusResistance())} )
					end
				end
			end
		end

		ScreenShake(self:GetParent():GetOrigin(), 10.0, 100.0, 0.5, 1300.0, 0, true)

		UTIL_Remove(self:GetParent())
	end
end



modifier_creature_command_restricted = class({})

function modifier_creature_command_restricted:IsHidden() return true end
function modifier_creature_command_restricted:IsPurgable() return false end

function modifier_creature_command_restricted:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end

