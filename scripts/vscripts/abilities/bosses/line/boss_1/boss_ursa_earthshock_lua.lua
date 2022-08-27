boss_ursa_earthshock_lua = class({})
LinkLuaModifier( "modifier_boss_ursa_earthshock_lua", "abilities/bosses/line/boss_1/boss_ursa_earthshock_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_ursa_earthshock_lua:OnSpellStart()
	if not IsServer() then return end
	local distance = self:GetSpecialValueFor("distance")
	local points = self:GetSpecialValueFor("points")
	local radius = self:GetSpecialValueFor("radius")
	local delay = self:GetSpecialValueFor("delay")
	local spacing = distance / points
	local range = 0
	local caster_pos = self:GetCaster():GetOrigin()
	local front = self:GetCaster():GetForwardVector():Normalized()

	Timers:CreateTimer(function()
		range = range + spacing
		local point_loc = self:GetCaster():GetOrigin() + front * range
		
		local dummy = CreateUnitByName("npc_dummy_unit", point_loc, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		local particleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp.vpcf", PATTACH_ABSORIGIN, dummy)
		dummy:AddNewModifier(self:GetCaster(), nil, "modifier_kill", {duration = 0.03})
		
		self:PlayEffects(point_loc)

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			for _,enemy in pairs(enemies) do
				ability_damage = enemy:GetMaxHealth()/100*self:GetSpecialValueFor("damage")
				local damage = {
					victim = enemy,
					attacker = self:GetCaster(),
					damage = ability_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self
				}
				ApplyDamage( damage )

				enemy:AddNewModifier(
					self:GetCaster(),
					self,
					"modifier_boss_ursa_earthshock_lua",
					{ duration = 4 }
				)
			end
		points = points - 1
			if points > 0 then
				return delay
			else
				return nil
			end
		end
	)
end

function boss_ursa_earthshock_lua:PlayEffects(point_loc)
	local sound_cast = "Hero_Ursa.Earthshock"
	local particle_cast = "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf"
	local slow_radius = self:GetSpecialValueFor("shock_radius")
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point_loc )
	ParticleManager:SetParticleControlForward( effect_cast, 0, point_loc )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(slow_radius/2, slow_radius/2, slow_radius/2) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetCaster() )
end


--------------------------------------------------------------------------------

modifier_boss_ursa_earthshock_lua = class({})

function modifier_boss_ursa_earthshock_lua:IsDebuff()
	return true
end

function modifier_boss_ursa_earthshock_lua:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_boss_ursa_earthshock_lua:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_boss_ursa_earthshock_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_boss_ursa_earthshock_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_boss_ursa_earthshock_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_earthshock_modifier.vpcf"
end

function modifier_boss_ursa_earthshock_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end