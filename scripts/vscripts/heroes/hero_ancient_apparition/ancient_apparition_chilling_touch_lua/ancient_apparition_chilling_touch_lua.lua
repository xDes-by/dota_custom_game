LinkLuaModifier("modifier_ancient_apparition_chilling_touch_lua", "heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_lua/ancient_apparition_chilling_touch_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)

ancient_apparition_chilling_touch_lua = class({})

function ancient_apparition_chilling_touch_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_int11") ~= nil then 
		return 10 + math.min(65000, self:GetCaster():GetIntellect()/400)
	end
	return 40 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function ancient_apparition_chilling_touch_lua:ProcsMagicStick()
	return false
end

function ancient_apparition_chilling_touch_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function ancient_apparition_chilling_touch_lua:GetProjectileName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf"
end

function ancient_apparition_chilling_touch_lua:GetCastRange()
	return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor("attack_range_bonus")
end

function ancient_apparition_chilling_touch_lua:OnOrbFire()
	self:GetCaster():EmitSound("Hero_Ancient_Apparition.ChillingTouch.Cast")
end

function ancient_apparition_chilling_touch_lua:OnOrbImpact( keys )
	if keys.target:IsMagicImmune() then return end
	keys.target:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Target")

	self.damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetIntellect() / 100 *  self:GetSpecialValueFor("int")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_agi_last") ~= nil then 
		self.damage = self.damage + self:GetCaster():GetAgility()*0.1
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_agi11") ~= nil and RandomInt(1,100) <= 15 then 
		self.damage = self.damage * 2.5
		proc = true
	end
	
	damage_type = DAMAGE_TYPE_MAGICAL
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str8") ~= nil then 
		self.damage = self.damage * 2
		damage_type = DAMAGE_TYPE_PHYSICAL
	end

	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_ancient_apparition_int50") ~= nil then 
		self.damage = self.damage + self:GetCaster():GetStrength() + self:GetCaster():GetIntellect() + self:GetCaster():GetAgility()
	end

	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_ancient_apparition_agi50") ~= nil and RollPercentage(15) then 
		local mult = self:GetCaster():GetIntellect()/5000 + 2
		if mult > 10 then
			mult = 10
		end
		self.damage = self.damage * mult
	end

	count = 0
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_agi10") ~= nil then 
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), keys.target:GetOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies > 0 then
			for _, enemy in pairs( enemies ) do
				if enemy ~= keys.target then
					count = count + 1
		 
						local projectile =
						{
							Target 				= enemy,
							Source 				= keys.target,
							Ability 			= self,
							EffectName 			= "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
							iMoveSpeed			= 600,
							vSourceLoc 			= keys.target:GetAbsOrigin(),
							bDrawsOnMinimap 	= false,
							bDodgeable 			= true,
							bIsAttack 			= false,
							bVisibleToEnemies 	= true,
							bReplaceExisting 	= false,
							flExpireTime 		= GameRules:GetGameTime() + 10,
							bProvidesVision 	= true,
							iVisionRadius 		= 400,
							iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
							ExtraData = extra_data
						}

					ProjectileManager:CreateTrackingProjectile(projectile);
						
			
					ApplyDamage({
						victim 			= enemy,
						damage 			= self.damage,
						damage_type		= damage_type,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
					})
					if count == 1 then break end
				end
			end
		end
	end
	
	ApplyDamage({
		victim 			= keys.target,
		damage 			= self.damage,
		damage_type		= damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
	})
	
	if proc then
		self:PlayEffects( keys.target, self:GetCaster() )
		proc = false
	end
end

function ancient_apparition_chilling_touch_lua:PlayEffects( target, caster )
	local crit_pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_crit_tgt_line_sparks.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(crit_pfx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(crit_pfx)

	EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target )
end