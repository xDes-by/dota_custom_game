enchantress_impetus_lua = class({})
LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function enchantress_impetus_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end


function enchantress_impetus_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local particle_projectile = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf"
	local sound_cast = "Hero_Enchantress.Impetus"

	local projectile_speed = caster:GetProjectileSpeed()
	local vision_radius = 300

	EmitSoundOn(sound_cast, caster)    

	local searing_arrow_active
	searing_arrow_active = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_projectile,
		iMoveSpeed = projectile_speed,
		bDodgeable = true, 
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = true,        
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber()      
		}

	ProjectileManager:CreateTrackingProjectile(searing_arrow_active)
end

function enchantress_impetus_lua:OnProjectileHit(target, location)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local sound_hit = "Hero_Clinkz.SearingArrows.Impact"

		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end

		EmitSoundOn(sound_hit, target)
		caster:PerformAttack(target, false, true, true, false, false, false, true)
	end
end

function enchantress_impetus_lua:GetProjectileName()
	return "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf"
end


function enchantress_impetus_lua:GetManaCost(iLevel)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int8") 
local level = self:GetLevel() / 2       
	if abil ~= nil then 
		local ability = self:GetCaster():FindAbilityByName("enchantress_natures")
			if ability:GetLevel() > 0 then
				mp_loss = ability:GetSpecialValueFor("mana_cost") * 0.01
				 return ((self:GetCaster():GetIntellect()/2) - (self:GetCaster():GetIntellect() * mp_loss))
			end	
		return (self:GetCaster():GetIntellect() / 2)
	end
---------------------------------------------------------------------------------------------------------------------------------
		local ability = self:GetCaster():FindAbilityByName("enchantress_natures")
			if ability:GetLevel() > 0 then
				mp_loss = ability:GetSpecialValueFor("mana_cost") * 0.01
				 return (self:GetCaster():GetIntellect() - (self:GetCaster():GetIntellect() * 2 * mp_loss))
			end	
				return (self:GetCaster():GetIntellect() )
end


function enchantress_impetus_lua:OnOrbFire( params )
	-- play effects
	local sound_cast = "Hero_Enchantress.Impetus"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function enchantress_impetus_lua:OnOrbImpact( params )
	-- unit identifier
	local caster = self:GetCaster()
	local target = params.target
	

	-- load data
	local distance_cap = self:GetSpecialValueFor("distance_cap")
	local distance_dmg = self:GetSpecialValueFor("distance_damage_pct")
	
	-- calculate distance & damage
	local distance = math.min( (caster:GetOrigin()-target:GetOrigin()):Length2D(), distance_cap )
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_agi11")
	if abil ~= nil	then 
	distance_dmg = distance_dmg + 10 
	end
	
	local damage = distance_dmg/100 * distance
	if caster:FindAbilityByName("npc_dota_hero_enchantress_int_last") ~= nil then
		damage = damage + self:GetCaster():GetIntellect() * 0.3
	end
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- play effects
	local sound_cast = "Hero_Enchantress.ImpetusDamage"
	EmitSoundOn( sound_cast, target )
end