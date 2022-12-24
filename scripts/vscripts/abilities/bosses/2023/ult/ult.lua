LinkLuaModifier("modifier_hero_destroyer_ult", "abilities/bosses/2023/ult/ult", LUA_MODIFIER_MOTION_NONE)

hero_destroyer_ult = class({})

function hero_destroyer_ult:OnSpellStart()
	local try_damage = self:GetSpecialValueFor("damage")

	local projectile_name = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam.vpcf"
	local projectile_speed = 600

	local info = {
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,
		bReplaceExisting = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	for _,enemy in pairs(enemies) do
		local damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = enemy:GetMaxHealth()/100*try_damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 3})
	end
	self:PlayEffects( )
	self:start_split()
end

function hero_destroyer_ult:PlayEffects( )
	local particle_cast = "particles/destr2.vpcf"
	local sound_cast = "Hero_EarthShaker.EchoSlam"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self:GetSpecialValueFor("radius"), 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetCaster() )
end

-------------------------------------------------------------------------------------------

function hero_destroyer_ult:start_split()
    if not IsServer() then return end

	local caster = self:GetCaster()
	local caster_position = caster:GetAbsOrigin()
	
	
	local line_pos = caster_position + caster:GetForwardVector() * 1600
	local rotation_rate = 360 / 5
		
	for i = 1, 5 do
		line_pos = RotatePosition(caster_position, QAngle(0, rotation_rate, 0), line_pos)
	
		local radius = 1600
		local duration = 3

		local effect_delay = 2
		local crack_width = 300
		local crack_distance = 1600
		local crack_damage = self:GetSpecialValueFor("damage")
		local caster_fw = caster:GetForwardVector()
		local crack_ending = line_pos

		-- Play cast sound
		EmitSoundOn("Hero_ElderTitan.EarthSplitter.Cast", caster)

		-- Add start particle effect
		local particle_start_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle_start_fx, 0, caster_position)
		ParticleManager:SetParticleControl(particle_start_fx, 1, crack_ending)
		ParticleManager:SetParticleControl(particle_start_fx, 3, Vector(0, effect_delay, 0))

		GridNav:DestroyTreesAroundPoint(line_pos, radius, false)

		Timers:CreateTimer(effect_delay, function()
			EmitSoundOn("Hero_ElderTitan.EarthSplitter.Destroy", caster)

			local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster_position, crack_ending, nil, crack_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			for _, enemy in pairs(enemies) do
				enemy:Interrupt()
				ApplyDamage({victim = enemy, attacker = caster, damage = enemy:GetMaxHealth()/100*crack_damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self})
				ApplyDamage({victim = enemy, attacker = caster, damage = enemy:GetMaxHealth()/100*crack_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
			end
			ParticleManager:ReleaseParticleIndex(particle_start_fx)
		end)
	end
end