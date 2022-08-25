ark_spark_lua = class({})

function ark_spark_lua:GetManaCost(iLevel)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int8")
		if abil ~= nil then
		return self:GetCaster():GetIntellect()/2
		else
        return self:GetCaster():GetIntellect()	
	end
end

function ark_spark_lua:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
		local damage = self:GetSpecialValueFor("damage")
		local enemy_speed = self:GetSpecialValueFor("enemy_speed")
		local caster_loc = caster:GetAbsOrigin()
		caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int9")
		if abil == nil then 
			enemy = enemies[1]
			end
			
			local enemy_projectile =
				{
					Target = enemy,
					Source = caster,
					Ability = self,
					EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = enemy_speed,
					flExpireTime = GameRules:GetGameTime() + 60,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				}
				

			ProjectileManager:CreateTrackingProjectile(enemy_projectile)
		end
	end
end

function ark_spark_lua:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if IsServer() then
		local caster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage")	
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_agi7")
		if abil ~= nil then 
		damage = damage + caster:GetAgility()
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int10")
		if abil ~= nil then 
		damage = damage + caster:GetIntellect()*0.75
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int11")
		if abil ~= nil then
		damage = damage * 2
		end
	
		ApplyDamage({attacker = caster, victim = target, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
		target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
	end
end