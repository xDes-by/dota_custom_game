hero_destroyer_first_skill_totem = class({})
LinkLuaModifier( "modifier_hero_destroyer_first_skill_totem_thinker", "abilities/bosses/2023/first_skill/first_skill", LUA_MODIFIER_MOTION_NONE )


function hero_destroyer_first_skill_totem:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function hero_destroyer_first_skill_totem:OnSpellStart()
	self.point = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local regen = self:GetSpecialValueFor("regen")
	
	
	local center = CreateModifierThinker( self:GetCaster(), self, "modifier_hero_destroyer_first_skill_totem_thinker", { duration = duration +0.2}, self.point, self:GetCaster():GetTeamNumber(), false )

	self:PlayEffects( self.point, duration )
end

function hero_destroyer_first_skill_totem:PlayEffects( point, duration )
	local sound_cast = "Hero_EarthShaker.Attack"
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

---------------------------------------------------------------------------------

modifier_hero_destroyer_first_skill_totem_thinker = class({})

function modifier_hero_destroyer_first_skill_totem_thinker:IsHidden()
	return false
end

function modifier_hero_destroyer_first_skill_totem_thinker:IsPurgable()
	return false
end

function modifier_hero_destroyer_first_skill_totem_thinker:OnCreated( kv )
if not IsServer() then return end
	local effect_cast = ParticleManager:CreateParticle( "particles/destr.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetAbility().point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 700, 0, 0 ) )
	self:StartIntervalThink(0.1)
end

function modifier_hero_destroyer_first_skill_totem_thinker:OnIntervalThink()
if not IsServer() then return end
	local try_damage = self:GetAbility():GetSpecialValueFor("damage")
	local regen = self:GetAbility():GetSpecialValueFor("regen")
	
	local all_units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetAbility().point, nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	for _,unit in pairs(all_units) do
		if unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			unit:Heal(unit:GetMaxHealth()/100 * regen, self:GetAbility())
			SendOverheadEventMessage( unit:GetPlayerOwner(), OVERHEAD_ALERT_HEAL , unit, unit:GetMaxHealth()/100 * self:GetAbility():GetSpecialValueFor("regen"), nil )
		else
			local damageTable = {
				victim = unit,
				attacker = self:GetCaster(),
				damage = try_damage * unit:GetMaxHealth()/100,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
				
			unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {
					center_x			= self:GetAbility().point[1] + 1,
					center_y			= self:GetAbility().point[2] + 1,
					center_z			= self:GetAbility().point[3],
					duration			= 0.4 * (1 - unit:GetStatusResistance()),
					knockback_duration	= 0.4 * (1 - unit:GetStatusResistance()),
					knockback_distance	= self:GetAbility():GetSpecialValueFor("back"),
					knockback_height	= 0,
					should_stun			= 0
				})	
		end
	end	

	ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(ShieldParticle, 1, Vector(self:GetAbility():GetSpecialValueFor("radius")+150,0,self:GetAbility():GetSpecialValueFor("radius")+150))
	ParticleManager:SetParticleControlEnt(ShieldParticle, 0, nil, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetAbility().point, true)
	EmitSoundOnLocationWithCaster( self:GetAbility().point, "Hero_EarthShaker.Arcana.run_alt1", self:GetCaster() )
	
	self:StartIntervalThink(-1)
	self:StartIntervalThink(1)
end