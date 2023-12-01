LinkLuaModifier( "modifier_arc_talent_int12", "heroes/hero_arc/arc_spark/modifier_arc_talent_int12", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_talent_int9", "heroes/hero_arc/arc_spark/modifier_arc_talent_int9", LUA_MODIFIER_MOTION_NONE )

ark_spark_lua = class({})
function ark_spark_lua:GetManaCost(iLevel)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int8")
	if abil ~= nil then
		return 50 + math.min(65000, self:GetCaster():GetIntellect() / 200)
	else
        return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
	end
end

function ark_spark_lua:GetIntrinsicModifierName()
	return "modifier_arc_talent_int12"
end

function ark_spark_lua:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
		local damage = self:GetSpecialValueFor("damage")
		local enemy_speed = self:GetSpecialValueFor("enemy_speed")
		local caster_loc = caster:GetAbsOrigin()
		caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")
		count = 1
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_arc_warden_int50") then
			count = 2
		end
		Timers:CreateTimer(0, function()
			count = count -1
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
			
				enemy = enemies[1]
				
				ProjectileManager:CreateTrackingProjectile({
					Target = enemy,
					Source = caster,
					Ability = self,
					EffectName = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_prj.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = enemy_speed,
					flExpireTime = GameRules:GetGameTime() + 60,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				})
			end
			if count > 0 then
				return 0.3
			end
		end	)
	end
end

function ark_spark_lua:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if IsServer() then
		if not target then return end
		local caster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage") + (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()) * self:GetSpecialValueFor("attributes_to_damage")

		if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_agi7") ~= nil then 
			damage = damage + caster:GetAgility()
		end
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int10") ~= nil then 
			damage = damage + caster:GetIntellect()*0.75
		end
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int11") ~= nil then
			damage = damage * 2
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int9") ~= nil then
			target:AddNewModifier(self:GetCaster(), self, "modifier_arc_talent_int9", {duration = 15})
		end
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("aoe_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ApplyDamage({attacker = caster, victim = enemy, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
		end
		target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
	end
end